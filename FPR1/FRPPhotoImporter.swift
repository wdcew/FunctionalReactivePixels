//  FRPPhotoImporter.swift
//  FPR
//
//  Created by 高冠东 on 8/26/16.
//  Copyright © 2016 高冠东. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Result
import YYModel

class FRPPhotoImporter: NSObject {
 typealias DictType = Dictionary<String, AnyObject>
    
    static func popualUrlRequest () -> NSURLRequest {
        return PXRequest.apiHelper().urlRequestForPhotoFeature(PXAPIHelperPhotoFeature.Popular, resultsPerPage: 100, page: 0, photoSizes: PXPhotoModelSize.Thumbnail, sortOrder: PXAPIHelperSortOrder.Rating, except: PXPhotoModelCategory.PXPhotoModelCategoryNude)
    }
    
    class func detailPhotoURLRequest(model: FRPPhotoModel) -> NSURLRequest {
        return PXRequest.apiHelper().urlRequestForPhotoID(model.identifier!.integerValue, photoSizes: PXPhotoModelSize.Large , commentsPage: -1)
    }
    
    class func fetchDetailPhoto(model model: FRPPhotoModel) -> SignalProducer<NSData, NoError> {
        let request = FRPPhotoImporter.detailPhotoURLRequest(model)
        return NSURLSession.sharedSession().rac_dataWithRequest(request)
            .replayLazily(1)
            .map({ (data, response) in
                let result = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! DictType
                let photoinfo = result!["photo"] as! DictType
                self.configureModel(model, witDictionary: photoinfo)
                self.downloadFullimage(withModel: model)
                
                return data
            })
            .flatMapError({ (error) in
                log.warning(error)
                return SignalProducer.empty
            })
    }
    
    class func inportPhotos () -> SignalProducer<[FRPPhotoModel],NSError> {
        let (singal, observer) = Signal<[FRPPhotoModel], NSError>.pipe()
        let producer = SignalProducer.init(signal: singal).replayLazily(1)
        let request = self.popualUrlRequest()
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) in
            if let vaildData = data {
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
                //订阅者发送数据
                observer.sendNext(models)
                observer.sendCompleted()
            } else {
                //数据错误
                observer.sendFailed(error!)
                
            }
        }
        return producer
    }
    
    class func configureModel(model: FRPPhotoModel, witDictionary dict: DictType) {
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
    
    class func urlForImageSize(imageSize: Int, inDictionary imags: Array<DictType>) -> String {
        let image = imags
            .filter {($0["size"] as! Int) <= imageSize}
            .map {$0["url"]}.first
        return image as! String
    }
    
    class func downloadFullimage(withModel model: FRPPhotoModel) {
        download(URL: model.fullsizedURL!)
            .startWithNext { (data) in
                model.fullsizedData = data
        }
    }
    
    class func downloadThumbnail(withModel model: FRPPhotoModel) {
        download(URL: model.thumbnailURL)
            .startWithNext { (data) in
                model.thumbnailData = data
        }
    }
    
    class func download(URL str: String?) -> SignalProducer<NSData,NoError> {
        guard let url = str else {return SignalProducer.empty}
        let request = NSURLRequest(URL: NSURL.init(string: url)!)
        return NSURLSession.sharedSession().rac_dataWithRequest(request)
            .map({ (data, response) in
                return data
            })
            .flatMapError() {
                //下载数据错误返回空的Singal
                log.warning($0)
                return SignalProducer.empty
            }
            .observeOn(UIScheduler())
    }
}
