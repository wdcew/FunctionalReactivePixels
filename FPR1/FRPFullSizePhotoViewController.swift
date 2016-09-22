
//  FRPFullSizePhotoViewController.swift
//  FPR1
//
//  Created by wdcew on 5/30/16.
//  Copyright © 2016 wdcew. All rights reserved.
//

import UIKit
import ReactiveCocoa
import SVProgressHUD

class FRPFullSizePhotoViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    //MARK: Store Property
    var viewModel: FRPFullSizePhotoViewModel
    
    lazy var pageViewController: UIPageViewController = {
        let vc = UIPageViewController.init(transitionStyle:.Scroll, navigationOrientation: .Horizontal,
                                           options: [UIPageViewControllerOptionInterPageSpacingKey : 30])
        vc.delegate = self
        vc.dataSource = self
        return vc
    } ()
    
    //MARK: - liferCycle method
    init(modelArray models: [FRPPhotoModel], PhotoIndex index: Int) {
        self.viewModel = FRPFullSizePhotoViewModel.init(models: models, atIndex: index)
        super.init(nibName: nil, bundle: nil)
        title = models[index].photoName
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.darkGrayColor()
        
        self.addChildViewController(pageViewController)
        
        pageViewController.setViewControllers([photoViewController(forIndex: viewModel.initIndex)!],
                                                   direction: UIPageViewControllerNavigationDirection.Forward, animated: true) {$0}
        pageViewController.view.frame = view.bounds
        view.addSubview(pageViewController.view)
        
    }
    
    //MARK: custom method
    func photoViewController(forIndex index: Int) -> FRPPhotoViewController? {
        return FRPPhotoViewController.init(withModel: viewModel.photoModels[index], index: index)
    }
    
}
   //MARK: - UIPageViewControllerDataSource
typealias PageViewControllerDataSource = FRPFullSizePhotoViewController
extension PageViewControllerDataSource {
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        return self.photoViewController(forIndex: viewModel.initIndex + 1)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        return self.photoViewController(forIndex: viewModel.initIndex - 1)
    }
    
}

    //MARK: - UIPageViewControllerDelegate
typealias PageViewControllerDelegate = FRPFullSizePhotoViewController
extension PageViewControllerDelegate {
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
//        pageViewController.viewControllers?.first?.title = pageViewController.viewControllers?.first as!
    }
}
