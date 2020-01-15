//
//  ViewController.swift
//  Example
//
//  Created by Csaba Toth on 2020. 01. 08..
//  Copyright © 2020. Pixlee. All rights reserved.
//

import UIKit

enum PXLAlbumViewControllerDisplayDisplayMode {
    case grid
    case list
}

class ViewController: UIViewController {
    static let PXLAlbumViewControllerDefaultMargin: CGFloat = 15
    @IBOutlet var collectionView: UICollectionView!
    let gridLayout = UICollectionViewFlowLayout()
    let listLayout = UICollectionViewFlowLayout()

    let album = PXLAlbum.albumWithIdentifier(identifier: "4515393")

    var albumDisplayMode = PXLAlbumViewControllerDisplayDisplayMode.grid {
        didSet {
            collectionView.setCollectionViewLayout(layoutToUse, animated: false)
        }
    }

    var layoutToUse: UICollectionViewLayout {
        albumDisplayMode == .grid ? gridLayout : listLayout
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let viewWidth = view.bounds.width
        let cellWidth = Int((viewWidth - 3 * ViewController.PXLAlbumViewControllerDefaultMargin) / 2)

        gridLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        gridLayout.sectionInset = UIEdgeInsets(top: ViewController.PXLAlbumViewControllerDefaultMargin,
                                               left: ViewController.PXLAlbumViewControllerDefaultMargin,
                                               bottom: ViewController.PXLAlbumViewControllerDefaultMargin,
                                               right: ViewController.PXLAlbumViewControllerDefaultMargin)

        listLayout.itemSize = CGSize(width: viewWidth, height: viewWidth)

        collectionView.setCollectionViewLayout(layoutToUse, animated: false)

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "PXLImageCell", bundle: nil), forCellWithReuseIdentifier: PXLImageCell.defaultIdentifier)

//        #warning Replace with your Pixlee API key.
        PXLClient.sharedClient.apiKey = "Hz7VLPHt7ow-oY992rJi"
//        #warning Replace with your Secret Key if you are making POST requests.
        PXLClient.sharedClient.secretKey = "secret"

        _ = PXLClient.sharedClient.getPhotoWithId(photoId: "299469263") { newPhoto, error in
            guard error == nil else {
                print("Error during load of image with Id \(String(describing: error))")
                return
            }
            guard let photo = newPhoto else {
                print("cannot find photo")
                return
            }
            print("New Photo: \(photo)")
        }

//        let albumWithIdentifier = PXLAlbum.albumWithIdentifier(identifier: "4515393")
//        let albumWithSKU = PXLAlbum.albumWithSku(sku: 300152)
        _ = PXLClient.sharedClient.loadNextPageOfPhotosForAlbum(album: album) { _, error in
            guard error == nil else {
                print("There was an error during the loading \(String(describing: error))")
                return
            }

            self.collectionView.reloadData()
        }
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return album.photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PXLImageCell.defaultIdentifier, for: indexPath) as! PXLImageCell

        cell.viewModel = album.photos[indexPath.row]

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageDetailsVC = ImageDetailsViewController(nibName: "ImageDetailsViewController", bundle: nil)
        let navController = UINavigationController(rootViewController: imageDetailsVC)

        imageDetailsVC.viewModel = album.photos[indexPath.row]

        present(navController, animated: true) {
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            let offset = scrollView.contentOffset.y + scrollView.frame.height
            if offset > scrollView.contentSize.height * 0.7 {
                _ = PXLClient.sharedClient.loadNextPageOfPhotosForAlbum(album: album) { photos, error in
                    guard error == nil else {
                        print("Error while loading images:\(String(describing: error))")
                        return
                    }
                    guard let photos = photos else { return }

                    var indexPaths = [IndexPath]()
                    let firstIndex = self.album.photos.firstIndex { (photo) -> Bool in
                        if let newPhoto = photos.first {
                            return photo.id == newPhoto.id
                        }
                        return false
                    } ?? 0

                    for (index, _) in photos.enumerated() {
                        let itemNumber = firstIndex + index
                        indexPaths.append(IndexPath(item: itemNumber, section: 0))
                    }

                    self.collectionView.insertItems(at: indexPaths)
                }
            }
        }
    }
}
