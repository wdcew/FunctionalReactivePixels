//
//  FRPPhotoViewModel.swift
//  FPR1
//
//  Created by wdcew on 9/6/16.
//  Copyright © 2016 wdcew. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Rex

class FRPPhotoViewModel: NSObject {
    let photoModel: FRPPhotoModel
    let fullImage = MutableProperty<UIImage?>.init(nil)
    var loading = MutableProperty<Bool>.init(true)
    
    init(model: FRPPhotoModel) {
        self.photoModel = model
        super.init()
        /** 获取fullPhto 的model **/
        downloadPhotoModelDetails()
        /** bind **/
        fullImage <~ DynamicProperty.init(object: model, keyPath: "fullsizedData").producer
            .map({
                if let data = $0 {
                    return UIImage.init(data: data as! NSData)
                }
                return nil
            })
    }
    
    func downloadPhotoModelDetails() {
        FRPPhotoImporter.fetchDetailPhoto(model: photoModel)
            .startWithNext({[weak self] _ in
                self?.loading.value = true
            })
    }
}

