//
//  MemeCollectionViewController.swift
//  MemeProject
//
//  Created by Mike Allan on 2020-05-18.
//  Copyright © 2020 Mindworks Software Design, Inc. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class MemeCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var memes: [Meme]! {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        calculateFlowLayoutDimensions()
    }
    
    func calculateFlowLayoutDimensions() {
        let space: CGFloat = 2.0
        var imagesPerRow:CGFloat = 3.0
        if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
            imagesPerRow = 4.0
        }
        let dimension = (view.frame.size.width - (2 * space)) / imagesPerRow
        print("view.frame.size.width = \(view.frame.size.width), space = \(space), dimension = \(dimension)")
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    // MARK: UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }

    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memeDetailViewCell", for: indexPath) as! MemeCollectionViewCell
    
        let meme = self.memes[indexPath.row]
        cell.memeImageView.image = meme.memedImage
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let memeDetailViewController = self.storyboard!.instantiateViewController(identifier: "memeDetailViewController") as! MemeDetailViewController
        let meme = self.memes[indexPath.row]
        memeDetailViewController.meme = meme
        self.navigationController!.pushViewController(memeDetailViewController, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        calculateFlowLayoutDimensions()
        flowLayout.invalidateLayout()
    }

}
