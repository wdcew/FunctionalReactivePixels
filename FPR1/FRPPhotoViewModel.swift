//
//  FRPPhotoViewModel.swift
//  FPR1
//
//  Created by wdcew on 9/6/16.
//  Copyright © 2016 wdcew. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FRPPhotoViewModel: NSObject {
    let photoModel: FRPPhotoModel
    let fullImage: Variable<UIImage?>
    
    var loading = BehaviorSubject<Bool>(value: true)
   
    init(model: FRPPhotoModel) {
        self.photoModel = model
        self.fullImage = Variable.init(nil)
        super.init()
        /** 获取fullPhto 的data **/
        downloadPhotoData()
        /** bind **/
        model.rx_observeWeakly(NSData.self, "fullsizedData")
            .map({ (data) -> UIImage? in
                if let data = data {
                    return UIImage.init(data: data)
                }
                return nil
            })
            .bindTo(fullImage)
    }
    
    func downloadPhotoData() {
        FRPPhotoImporter.fetchDetailPhoto(photoModel)
            .subscribeNext ({[weak self] _ in
                self?.loading.onNext(false)
                })
            
    }
}

