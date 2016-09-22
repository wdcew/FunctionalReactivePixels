//  FRPPhotoImporter.swift
//  FPR
//
//  Created by wdcew on 5/26/16.
//  Copyright © 2016 wdcew. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FRPPhotoImporter: NSObject {
 typealias DictType = Dictionary<String, AnyObject>
    
    private static func popualUrlRequest () -> NSURLRequest {
        return PXRequest.apiHelper().urlRequestForPhotoFeature(PXAPIHelperPhotoFeature.Popular, resultsPerPage: 100, page: 0, photoSizes: PXPhotoModelSize.Thumbnail, sortOrder: PXAPIHelperSortOrder.Rating, except: PXPhotoModelCategory.PXPhotoModelCategoryNude)
    }
    
    private static func detailPhotoURLRequest(model: FRPPhotoModel) -> NSURLRequest {
        return PXRequest.apiHelper().urlRequestForPhotoID(model.identifier!.integerValue, photoSizes: PXPhotoModelSize.Large , commentsPage: -1)
    }
    
    static func fetchDetailPhoto(model: FRPPhotoModel) -> Observable<(NSData, NSHTTPURLResponse)> {
        let request = FRPPhotoImporter.detailPhotoURLRequest(model)
       
        //将 冷信号，转为热信号
        let connection = NSURLSession.sharedSession().rx_response(request).shareReplay(1)
        connection.subscribeNext { (data, respose) in
            let result = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! DictType
            let photoinfo = result!["photo"] as! DictType
            self.configureModel(model, witDictionary: photoinfo)
            self.downloadFullimage(withModel: model)
        }
        return connection
    }
    
    static func importPhotos() -> Observable<[FRPPhotoModel]> {
        let request = self.popualUrlRequest()
        let connection = NSURLSession.sharedSession().rx_response(request)
            .shareReplay(1)
            .map { (vaildData, response) -> [FRPPhotoModel] in
                let result = try? NSJSONSerialization.JSONObjectWithData(vaildData, options: NSJSONReadingOptions.MutableContainers) as! DictType
                
                let photos = result!["photos"] as! Array<AnyObject>
                let models = photos
                    .map({ (obj) ->  FRPPhotoModel in
                        let model = FRPPhotoModel.init()
                        //将josn转化为model
                        configureModel(model, witDictionary: obj as! DictType)
                        self.downloadThumbnail(withModel: model)
                        
                        return model
                    })
                return models
        }
        return connection
    }
    
    static func configureModel(model: FRPPhotoModel, witDictionary dict: DictType) {
        model.photoName = dict["name"] as? String
        model.identifier = dict["id"] as? NSNumber
        let user = dict["user"] as! NSDictionary
        model.photographerName = user["username"] as? String
        
        let images = dict["images"] as! Array<DictType>
        model.thumbnailURL = urlForImageSize(4, inDictionary: images)
        
        if let fullImageURLArray = dict["image_url"] {
            let array = fullImageURLArray as! Array<AnyObject>
            model.fullsizedURL = array.first as? String
            
        }
    }
    
    static func urlForImageSize(imageSize: Int, inDictionary imags: Array<DictType>) -> String {
        let image = imags
            .filter {($0["size"] as! Int) <= imageSize}
            .map {$0["url"]}.first
        return image as! String
    }
    
    static func downloadFullimage(withModel model: FRPPhotoModel) {
        download(URL: model.fullsizedURL!)
            .subscribeNext({ (data, response) in
                model.fullsizedData = data
            })
    }
    
    static func downloadThumbnail(withModel model: FRPPhotoModel) {
        download(URL: model.thumbnailURL)
            .subscribeNext({ (data, response) in
                
                model.thumbnailData = data
            })
    }
    
    private class func download(URL str: String?) -> Observable<(NSData, NSHTTPURLResponse)> {
        
        guard let url = str else {return Observable.empty()}
        let request = NSURLRequest(URL: NSURL.init(string: url)!)
        let connect = NSURLSession.sharedSession().rx_response(request).shareReplay(1)
        connect.subscribeError({ (error) in
                //下载数据错误返回空的Singal
                log.warning(error)
            })
        return connect
    }
    
}
