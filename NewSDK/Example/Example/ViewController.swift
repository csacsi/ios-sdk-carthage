//
//  ViewController.swift
//  Example
//
//  Created by Csaba Toth on 2020. 01. 08..
//  Copyright © 2020. Pixlee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var tableView: UITableView!

    let album = PXLAlbum.albumWithIdentifier(identifier: "4515393")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ImageCell", bundle: nil), forCellReuseIdentifier: "ImageCell")

//        #warning Replace with your Pixlee API key.
        PXLClient.sharedClient.apiKey = "Hz7VLPHt7ow-oY992rJi"
//        #warning Replace with your Secret Key if you are making POST requests.
        PXLClient.sharedClient.secretKey = "secret"

        PXLPhoto.getPhotoWithId(photoId: "312011951") { newPhoto, _ in
            print("New Photo: \(newPhoto)")
        }

//        let albumWithIdentifier = PXLAlbum.albumWithIdentifier(identifier: "4515393")
//        let albumWithSKU = PXLAlbum.albumWithSku(sku: 300152)
        album.loadNextPageOfPhotos { photos, error in
            guard error == nil else {
                print("There was an error during the loading \(error)")
                return
            }
//            print("Photos: \(photos)")
            if let firstPhoto = photos?.first {
                print("First photo: \(firstPhoto.id)")
            }
            self.tableView.reloadData()
            self.album.loadNextPageOfPhotos { photos, error in
                guard error == nil else {
                    print("There was an error during the loading \(error)")
                    return
                }
//                print("Photos: \(photos)")
                if let firstPhoto = photos?.first {
                    print("First photo: \(firstPhoto.id)")
                }
                self.album.loadNextPageOfPhotos { photos, error in
                    guard error == nil else {
                        print("There was an error during the loading \(error)")
                        return
                    }
//                    print("Photos: \(photos)")
                    if let firstPhoto = photos?.first {
                        print("First photo: \(firstPhoto.id)")
                    }
                    self.album.loadNextPageOfPhotos { photos, error in
                        guard error == nil else {
                            print("There was an error during the loading \(error)")
                            return
                        }
//                        print("Photos: \(photos)")
                        if let firstPhoto = photos?.first {
                            print("First photo: \(firstPhoto.id)")
                        }
                    }
                }
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return album.photos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as! ImageCell

        cell.viewModel = album.photos[indexPath.row]

        return cell
    }
}
