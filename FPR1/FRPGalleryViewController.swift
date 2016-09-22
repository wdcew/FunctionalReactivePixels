//
//  FRPGallerCollectionViewController.swift
//  FPR
//
//  Created by wdcew on 5/26/16.
//  Copyright © 2016 wdcew. All rights reserved.
//

import UIKit
import Result
import ReactiveCocoa
import Rex

private let reuseIdentifier = "Cell"

class FRPGallerCollectionViewController: UICollectionViewController {
    //MARK: - Store Property
    let viewModel = FRPGalleryViewModel()
    
    //MARK: - lifeCycle
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Popular on 500px";
        self.collectionView!.registerClass(FRPCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        /** Bind Property **/
        bindToProperty()
        /** Delegate **/
        RACDelegate()
    }
    
    //MARK: RAC configurable method
    func bindToProperty () {
        
        viewModel.photoArray.asDriver()
            .driveNext ({[weak self] _ in
                self?.collectionView?.reloadData()
                })
    }
    
    func RACDelegate () {
        /** collectionDelegate **/
        self.rac_signalForSelector(#selector(UICollectionViewDelegate.collectionView(_:didSelectItemAtIndexPath:)),
                                   fromProtocol: UICollectionViewDelegate.self)
            .subscribeNext {[weak self] (tuple) in
                let tuple = tuple as! RACTuple
                let strongSelf = self
                let indexPath = tuple.second
                
                let vc = FRPFullSizePhotoViewController.init(modelArray: strongSelf!.viewModel.photoArray.value, PhotoIndex: indexPath.row)
                strongSelf!.navigationController?.pushViewController(vc, animated: true)
        }
        
    // Need to "reset" the cached values of respondsToSelector: of UIKit
    collectionView!.delegate = nil;
    collectionView!.delegate = self;
    }
}

//     MARK: - UICollectionViewDataSource
typealias UIcollectionViewDataSource = FRPGallerCollectionViewController
extension UIcollectionViewDataSource {
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return viewModel.photoArray.value.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! FRPCell
        cell.photoModel = viewModel.photoArray.value[indexPath.row]
        return cell
        
    }
}

    // MARK: - UICollectionViewDelegate
typealias collectionViewDelegate = FRPGallerCollectionViewController
extension collectionViewDelegate {
}
