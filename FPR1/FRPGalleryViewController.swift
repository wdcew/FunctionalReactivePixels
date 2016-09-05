//
//  FRPGallerCollectionViewController.swift
//  FPR
//
//  Created by 高冠东 on 8/26/16.
//  Copyright © 2016 高冠东. All rights reserved.
//

import UIKit
import Result
import ReactiveCocoa
import Rex

private let reuseIdentifier = "Cell"

class FRPGallerCollectionViewController: UICollectionViewController {
    //MARK: - Store Property
     let photoArray = MutableProperty([FRPPhotoModel]())
    
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
        /** binde photoArray，一旦其值发送变化，立即更新 **/
        weak var weakSelf = self
        photoArray.producer.startWithNext { (arrays) in
            let strongSelf = weakSelf
            strongSelf?.collectionView?.reloadData()
        }
        log.warning("")
        
        /** 获取 photosModel **/
        photoArray <~ FRPPhotoImporter.inportPhotos()
            .flatMapError({ (error) in
                print("could't obtan Photos JSON Data,Error: \(error)")
                return SignalProducer<[FRPPhotoModel], NoError>.empty
            })
    }
    
    func RACDelegate () {
        /** collectionDelegate **/
        weak var weakSelf = self
        self.rac_signalForSelector(#selector(UICollectionViewDelegate.collectionView(_:didSelectItemAtIndexPath:)),
                                   fromProtocol: UICollectionViewDelegate.self)
            .subscribeNext { (tuple) in
                let tuple = tuple as! RACTuple
                let strongSelf = weakSelf
                let indexPath = tuple.second
                
                let vc = FRPFullSizePhotoViewController.init(modelArray: strongSelf!.photoArray.value, PhotoIndex: indexPath.row)
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
        return photoArray.value.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! FRPCell
        cell.photoModel = photoArray.value[indexPath.row]
        return cell
        
    }
}

    // MARK: - UICollectionViewDelegate
typealias collectionViewDelegate = FRPGallerCollectionViewController
extension collectionViewDelegate {
}