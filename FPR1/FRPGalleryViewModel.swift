//
//  FRPGalleryViewModel.swift
//  FPR1
//
//  Created by wdcew on 9/5/16.
//  Copyright © 2016 wdcew. All rights reserved.
//

import UIKit
//import Result
//import ReactiveCocoa
//import Rex
import RxSwift
import RxCocoa

class FRPGalleryViewModel: NSObject {
    let photoArray: Variable<[FRPPhotoModel]>
    
    override init() {
        photoArray = Variable.init([FRPPhotoModel]())
        super.init()
        downloadPhtosModel()
    }
    /** 获取 photos model **/
    func downloadPhtosModel() {
        FRPPhotoImporter.importPhotos()
            .bindTo(photoArray)
        
        
    }
}
