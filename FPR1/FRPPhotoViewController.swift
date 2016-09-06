//
//  FRPPhotoViewController.swift
//  FPR1
//
//  Created by wdcew on 5/30/16.
//  Copyright © 2016 wdcew. All rights reserved.
//

import UIKit
import SVProgressHUD
import ReactiveCocoa
import Rex
class FRPPhotoViewController: UIViewController, UIScrollViewDelegate {
    //MARK: store property
    var index: Int?
    private var ViewModel: FRPPhotoViewModel
    
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
        self.ViewModel = FRPPhotoViewModel(model: model)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()
        
        /* set scrollView */
        scrollView.contentSize = view.bounds.size
        view.addSubview(scrollView)
        
        scrollView.addSubview(imageView)
        /* View Bind */
        imageView.rex_image <~ ViewModel.fullImage.producer
        
        ViewModel.loading.producer
            .observeOn(UIScheduler())
            .startWithNext({_ in
                SVProgressHUD.dismiss()
            })
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
}

//MARK: - ScrollView Delegate
typealias ScrollViewDelegate = FRPPhotoViewController
extension ScrollViewDelegate {
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}