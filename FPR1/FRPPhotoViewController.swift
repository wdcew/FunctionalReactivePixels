//
//  FRPPhotoViewController.swift
//  FPR1
//
//  Created by 高冠东 on 8/30/16.
//  Copyright © 2016 高冠东. All rights reserved.
//

import UIKit
import SVProgressHUD
import ReactiveCocoa

class FRPPhotoViewController: UIViewController, UIScrollViewDelegate {
    //MARK: store property
    var index: Int?
    private var photoModel: FRPPhotoModel?
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView.init(frame: self.view.bounds)
        view.maximumZoomScale = 2
        view.minimumZoomScale = 1
        view.bounces = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        
        view.delegate = self
        view.backgroundColor = UIColor.blackColor()
        return view
    }()
    
    lazy var imageView: UIImageView = {
        let view = UIImageView(frame: self.scrollView.bounds)
        view.backgroundColor = UIColor.blackColor()
        view.contentMode = UIViewContentMode.ScaleAspectFit
        
        return view
    }()
    
    //MARK: - lifecycle method
    init(withModel model: FRPPhotoModel, index: Int?) {
        self.index = index
        self.photoModel = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* set scrollView */
        scrollView.contentSize = view.bounds.size
        view.addSubview(scrollView)
        
        /* set imageview */
        RAC(imageView, "image") <~ RACObserve(photoModel!, "fullsizedData")
            .map(){value in
                if let value = value {
                    return UIImage.init(data: value as! NSData)
                }
                return nil
        }
        scrollView.addSubview(imageView)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        SVProgressHUD.show()
        FRPPhotoImporter.fetchDetailPhoto(model: photoModel!)
            .deliverOn(RACScheduler.mainThreadScheduler())
            .subscribeError({print($0)}) {
                SVProgressHUD.dismiss()
        }
    }
}

//MARK: - ScrollView Delegate
typealias ScrollViewDelegate = FRPPhotoViewController
extension ScrollViewDelegate {
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}