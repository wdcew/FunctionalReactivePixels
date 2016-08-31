
//  FRPFullSizePhotoViewController.swift
//  FPR1
//
//  Created by 高冠东 on 8/30/16.
//  Copyright © 2016 高冠东. All rights reserved.
//

import UIKit
import ReactiveCocoa
import SVProgressHUD

class FRPFullSizePhotoViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    //MARK: Store Property
    let subject: RACSubject = RACSubject()
    
    var photoModels: [FRPPhotoModel]?  = nil
    
    lazy var pageViewController: UIPageViewController = {
        let vc = UIPageViewController.init(transitionStyle:.Scroll, navigationOrientation: .Horizontal,
                                           options: [UIPageViewControllerOptionInterPageSpacingKey : 30])
        vc.delegate = self
        vc.dataSource = self
        return vc
    } ()
    
    //MARK: - liferCycle method
    init(modelArray models: [FRPPhotoModel], PhotoIndex index: Int) {
        photoModels = models
        super.init(nibName: nil, bundle: nil)
        title = models[index].photoName
        
        self.addChildViewController(pageViewController)
        self.pageViewController.setViewControllers([photoViewController(forIndex: index)!],
                                                   direction: UIPageViewControllerNavigationDirection.Forward, animated: true) {$0}
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.darkGrayColor()
        
        pageViewController.view.frame = view.bounds
        view.addSubview(pageViewController.view)
        
    }
    //MARK: custom method
    func photoViewController(forIndex index: Int) -> FRPPhotoViewController? {
        if index >= 0 && index <= photoModels!.count - 1  {
            return FRPPhotoViewController.init(withModel: photoModels![index], index: index)
        }
        return nil
    }
    
}
    //MARK: - UIPageViewControllerDelegate
typealias PageViewControllerDataSource = FRPFullSizePhotoViewController
extension PageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        return self.photoViewController(forIndex: (viewController as! FRPPhotoViewController).index! + 1)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        return self.photoViewController(forIndex: (viewController as! FRPPhotoViewController).index! - 1)
    }
    
}

typealias PageViewControllerDelegate = FRPFullSizePhotoViewController
extension PageViewControllerDelegate {
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        print(pageViewController.gestureRecognizers)
//        pageViewController.viewControllers?.first?.title = pageViewController.viewControllers?.first as! 
    }
}