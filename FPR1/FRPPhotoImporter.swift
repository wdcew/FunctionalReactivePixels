//
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
    
    class func fetchDetailPhoto(model model: FRPPhotoModel) -> RACSignal {
        let subject = RACReplaySubject()
        let request = self.self.detailPhotoURLRequest(model)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue()) { (response, data, error) in
            if let data = data {
                let result = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! DictType
                
                let photoinfo = result!["photo"] as! DictType
                self.configureModel(model, witDictionary: photoinfo)
                self.downloadFullimage(withModel: model)
                
                subject.sendNext(model)
                subject.sendCompleted()
            } else {
                //发生错误
                subject.sendError(error)
            }
        }
        return subject
    }
    
    class func inportPhotos () -> RACSignal {
        let subject = RACReplaySubject.init()
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
                subject .sendNext(models)
                subject.sendCompleted()
            } else {
                //数据错误
                subject .sendError(error)
            }
        }
        return subject
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
        let url = NSURL(string: model.fullsizedURL!)
        let request = NSURLRequest(URL: url!)
        NSURLConnection.sendAsynchronousRequest(request, queue:NSOperationQueue()) { (response, data, error) in
            if error != nil {
                print(error)
            }
            model.fullsizedData = data;
        }
    }
    
    class func downloadThumbnail(withModel model: FRPPhotoModel) {
        let url = NSURL(string: model.thumbnailURL!)
        let request = NSURLRequest(URL: url!)
        NSURLConnection.sendAsynchronousRequest(request, queue:NSOperationQueue()) { (response, data, error) in
            if error != nil {
                print(error)
            }
            model.thumbnailData = data;
            
        }
    }
    
}
