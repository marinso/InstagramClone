//
//  SelectImageVC.swift
//  InstagramClone
//
//  Created by Martin Nasierowski on 05/10/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.
//

import UIKit
import Photos

private let reuseIdentifier = "SelectImageCell"
private let headerIdentifier = "SelectImageHeader"

class SelectImageVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    
    var images = [UIImage]()
    var assets = [PHAsset]()
    var selectedImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.register(SelectImageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.register(SelectImageHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        
        configureNav()
        fetchPhotos()
    }
    
    // MARK: - UICollectionViewFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.size.width - 3) / 4
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.size.width
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    

    // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! SelectImageHeader
        if let selectedImage = self.selectedImage {
            
            if let index = self.images.lastIndex(of: selectedImage) {
                let selectedAssets = assets[index]
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width:600, height:600)
                
                imageManager.requestImage(for: selectedAssets, targetSize: targetSize, contentMode: .aspectFit, options: nil) { (image, info) in
                    if let image = image {
                        header.photoImageView.image = image
                    }
                }
            }
        }
        return header
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SelectImageCell
        cell.photoImageView.image = images[indexPath.row]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedImage = images[indexPath.row]
        collectionView.reloadData()
        let index = IndexPath(item:0, section: 0)
        collectionView.scrollToItem(at: index, at: .bottom, animated: true)
    }
    
    // MARK: - Handlers
    
    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleNext() {
        print("next")
    }
    
    func configureNav() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNext))
        navigationController?.navigationBar.tintColor = .black
    }
    
    func getAssetOptions() -> PHFetchOptions {
        let options = PHFetchOptions()
        options.fetchLimit = 30
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        options.sortDescriptors = [sortDescriptor]
        
        return options
    }
    
    func fetchPhotos() {
        let allPhotos = PHAsset.fetchAssets(with: .image, options: getAssetOptions())
        
        DispatchQueue.global(qos: .background).async {
            
            allPhotos.enumerateObjects { (asset, count , stop) in
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width:200, height:200)
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                
                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options) { (image, info) in
                    if let image = image {
                        self.images.append(image)
                        self.assets.append(asset)
                        if self.selectedImage == nil {
                            self.selectedImage = image
                        }
                        
                        if count == allPhotos.count-1 {
                            DispatchQueue.main.async {
                                self.collectionView.reloadData()
                            }
                        }
                    }
                }
                
            }
            
            
            
        }
    }
    
}
