//
//  FRPGalleryFlowLayout.swift
//  FPR
//
//  Created by 高冠东 on 8/26/16.
//  Copyright © 2016 高冠东. All rights reserved.
//

import UIKit

struct ItemSize {
    static let size = CGSize(width: 172, height: 172)
    static let inset = UIEdgeInsetsMake(10, 10, 10, 10)
}

class FRPGalleryFlowLayout:  UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        itemSize = ItemSize.size
        minimumInteritemSpacing = 10
        minimumLineSpacing = 10
        sectionInset = ItemSize.inset
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
