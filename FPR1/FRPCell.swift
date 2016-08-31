//
//  FRPCell.swift
//  FPR1
//
//  Created by 高冠东 on 8/29/16.
//  Copyright © 2016 高冠东. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Result

class FRPCell: UICollectionViewCell {
    weak var imagView: UIImageView?
    var subscription: RACDisposable?
    //MARK: - LifeCycle Method
    override init(frame: CGRect) {
        super.init(frame: frame)
        //进行初始化配置
        let view = UIImageView(frame: bounds)
        self.contentView.addSubview(view)
        imagView = view
        
        backgroundColor = UIColor.darkGrayColor()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup Method
    func setPhotoModel(Model :FRPPhotoModel) {
    
    subscription = RACObserve(Model, "thumbnailData")
        .filter() {$0 != nil}
        .map() {UIImage.init(data: $0 as! NSData)}
        .setKeyPath("image", onObject: self.imagView)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        subscription?.dispose()
        subscription = nil
    }
    
}
