//
//  FRPGallerCollectionViewController.swift
//  FPR
//
//  Created by 高冠东 on 8/26/16.
//  Copyright © 2016 高冠东. All rights reserved.
//

import UIKit
import ReactiveCocoa
private let reuseIdentifier = "Cell"

class FRPGallerCollectionViewController: UICollectionViewController {
    //MARK: - Store Property
    let photoArray = MutableProperty<[FRPPhotoModel]>([FRPPhotoModel]())
    
    
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
        
        self.loadPopularPhotos()
        
        weak var weakSelf = self
        
        photoArray.producer.startWithNext { (arrays) in
            let strongSelf = weakSelf
            strongSelf?.collectionView?.reloadData()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: custom method
    func loadPopularPhotos () {
        let subject = FRPPhotoImporter.inportPhotos()
        
        weak var weakSelf = self
        subject.subscribeNext { (value) in
            let strongSelf = weakSelf
            strongSelf!.photoArray.value = value as! [FRPPhotoModel]
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    

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
        cell.setPhotoModel(photoArray.value[indexPath.row])
        
        return cell
        
    }
}
    // MARK: - UICollectionViewDelegate

typealias collectionViewDelegate = FRPGallerCollectionViewController
extension collectionViewDelegate {
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let vc = FRPFullSizePhotoViewController.init(modelArray: photoArray.value, PhotoIndex: indexPath.row)
        
        navigationController?.pushViewController(vc, animated: true)
    }
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
}