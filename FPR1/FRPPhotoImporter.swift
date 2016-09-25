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
    /** 获取 popular 类别中所有图片的model **/
    fileprivate static func popualUrlRequest () -> URLRequest {
        return PXRequest.apiHelper().urlRequest(for: PXAPIHelperPhotoFeature.popular, resultsPerPage: 100, page: 0, photoSizes: PXPhotoModelSize.thumbnail, sortOrder: PXAPIHelperSortOrder.rating, except: PXPhotoModelCategory.PXPhotoModelCategoryNude)
    }
    /** 获取一张图片的详细 model **/
    fileprivate static func detailPhotoURLRequest(_ model: FRPPhotoModel) -> URLRequest {
        return PXRequest.apiHelper().urlRequest(forPhotoID: model.identifier!.intValue, photoSizes: PXPhotoModelSize.large , commentsPage: -1)
    }
    
    /** 下载大尺寸图片 **/
    static func fetchDetailPhoto(_ model: FRPPhotoModel) -> Observable<(Data, HTTPURLResponse)> {
        let request = FRPPhotoImporter.detailPhotoURLRequest(model)
       
        //将 冷信号，转为热信号
        let connection = URLSession.shared.rx.response(request).shareReplay(1)
        _ = connection
            .subscribe(onNext: { (data, respose) in
            let result = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! DictType
            let photoinfo = result!["photo"] as! DictType
            self.configureModel(model, witDictionary: photoinfo)
            self.downloadFullimage(withModel: model)
        })
        return connection
    }
    
    /** 获取 分类 中所有图片的model **/
    static func importPhotos() -> Observable<[FRPPhotoModel]> {
        //获取 popular 分类
        let request = self.popualUrlRequest()
        let connection = URLSession.shared.rx.response(request)
            .shareReplay(1)
            .map { (vaildData, response) -> [FRPPhotoModel] in
                let result = try? JSONSerialization.jsonObject(with: vaildData, options: JSONSerialization.ReadingOptions.mutableContainers) as! DictType
                
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
    
    static func configureModel(_ model: FRPPhotoModel, witDictionary dict: DictType) {
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
    
    static func urlForImageSize(_ imageSize: Int, inDictionary imags: Array<DictType>) -> String {
        let image = imags
            .filter {($0["size"] as! Int) <= imageSize}
            .map {$0["url"]}.first
        return image as! String
    }
    
    static func downloadFullimage(withModel model: FRPPhotoModel) {
        _ = download(URL: model.fullsizedURL!)
            .subscribe(onNext: { (data, response) in
                model.fullsizedData = data as Data
            })
    }
    
    static func downloadThumbnail(withModel model: FRPPhotoModel) {
        _ = download(URL: model.thumbnailURL)
            .subscribe(onNext: { (data, response) in
                
                model.thumbnailData = data as Data
            })
    }
    
    fileprivate class func download(URL str: String?) -> Observable<(Data, HTTPURLResponse)> {
        
        guard let url = str else {return Observable.empty()}
        let request = URLRequest(url: URL.init(string: url)!)
        let connect = URLSession.shared.rx.response(request).shareReplay(1)
        _ = connect
            .subscribe(onError: { (error) in
                
                let print = error as NSError
                log.warning(print.code)
            })
        return connect
    }
    
}
