//
//  FRPCell.swift
//  FPR1
//
//  Created by wdcew on 5/29/16.
//  Copyright © 2016 wdcew. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

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
        backgroundColor = UIColor.darkGray
        
        _ = self.rx.observe(Data.self, "photoModel.thumbnailData")
            .map ({ (data) -> UIImage? in
                if let data = data {
                    return UIImage.init(data: data )
                }
                return nil
            })
            .observeOn(MainScheduler.instance)
            .bindTo(imagView!.rx.image)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Setup Method
}
