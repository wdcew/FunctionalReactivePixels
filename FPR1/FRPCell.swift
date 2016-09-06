//
//  FRPCell.swift
//  FPR1
//
//  Created by wdcew on 5/29/16.
//  Copyright © 2016 wdcew. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Result

class FRPCell: UICollectionViewCell {
    weak var imagView: UIImageView?
    dynamic var photoModel :FRPPhotoModel?
    
    //MARK: - LifeCycle Method
    override init(frame: CGRect) {
        super.init(frame: frame)
        //进行初始化配置
        let view = UIImageView(frame: bounds)
        self.contentView.addSubview(view)
        imagView = view
        backgroundColor = UIColor.darkGrayColor()
        
        imagView!.rex_image <~ DynamicProperty.init(object: self, keyPath: "photoModel.thumbnailData")
            .signal
            .filterMap({ (value) -> UIImage? in
                if let data = value {
                    return UIImage.init(data: data as! NSData)
                }
                
                return nil
            })
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Setup Method
}
