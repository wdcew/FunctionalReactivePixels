//
//  FRPFullSizePhotoViewModel.swift
//  FPR1
//
//  Created by wdcew on 9/5/16.
//  Copyright © 2016 wdcew. All rights reserved.
//

import UIKit

class FRPFullSizePhotoViewModel: NSObject {
    let photoModels: [FRPPhotoModel]
    let photoName: String?
    let initIndex: Int
    
    init(models array: [FRPPhotoModel], atIndex index: Int) {
        self.photoModels = array
        self.initIndex = index
        self.photoName = array[index].photoName
    }
    
    func photoModelAtIndex(index index: Int) -> FRPPhotoModel?
    {
        if index < 0 || index > photoModels.count - 1 {
            return nil
        }
        return photoModels[index]
    }
}
