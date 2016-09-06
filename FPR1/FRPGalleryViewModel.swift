//
//  FRPGalleryViewModel.swift
//  FPR1
//
//  Created by wdcew on 9/5/16.
//  Copyright © 2016 wdcew. All rights reserved.
//

import UIKit
import Result
import ReactiveCocoa
import Rex

class FRPGalleryViewModel: NSObject {
    let photoArray: MutableProperty<[FRPPhotoModel]>
    
    override init() {
        photoArray = MutableProperty([FRPPhotoModel]())
        super.init()
        photoArray <~ downloadPhtosModel().producer
    }
    /** 获取 photos model **/
    func downloadPhtosModel() -> SignalProducer<[FRPPhotoModel],NoError> {
        return FRPPhotoImporter.importPhotos()
            .flatMapError({ (error) in
                log.warning("could't obtan Photos JSON Data,Error: \(error)")
                return SignalProducer<[FRPPhotoModel], NoError>.empty
            })
    }
}
