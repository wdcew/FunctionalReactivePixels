//
//  FRPGallerCollectionViewController.swift
//  FPR
//
//  Created by wdcew on 5/26/16.
//  Copyright © 2016 wdcew. All rights reserved.
//

import UIKit

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
        //配置VIew
        configView()
        /** Bind Property **/
        bindToProperty()
    }
    
    func configView() {
        self.title = "Popular on 500px";
        self.collectionView!.register(FRPCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        //navItem添加Butoon
        let btItem = UIBarButtonItem()
        btItem.title = "注册"
        btItem.target = self
        btItem.action = #selector(self.presentSignInVC)
        self.navigationItem.rightBarButtonItem = btItem
    }
    
    //MARK: RAC configurable method
    func bindToProperty() {
        
        _ = viewModel.photoArray.asDriver()
            .drive (onNext: {[weak self] _ in
                self?.collectionView?.reloadData()
                })
    }
    
//     MARK: - Action Function
    func presentSignInVC() {
        self.present(SignInViewController(), animated: true)
    }
    
}

//     MARK: - UICollectionViewDataSource
typealias UIcollectionViewDataSource = FRPGallerCollectionViewController
extension UIcollectionViewDataSource {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return viewModel.photoArray.value.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FRPCell
        cell.photoModel = viewModel.photoArray.value[indexPath.row]
        return cell
        
    }
}

    // MARK: - UICollectionViewDelegate
typealias collectionViewDelegate = FRPGallerCollectionViewController
extension collectionViewDelegate {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = FRPFullSizePhotoViewController.init(modelArray: viewModel.photoArray.value, PhotoIndex: indexPath.row)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
