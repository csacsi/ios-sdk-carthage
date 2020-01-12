//
//  ViewController.swift
//  Example
//
//  Created by Csaba Toth on 2020. 01. 08..
//  Copyright © 2020. Pixlee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

//        #warning Replace with your Pixlee API key.
        PXLClient.sharedClient.apiKey = "Hz7VLPHt7ow-oY992rJi"
//        #warning Replace with your Secret Key if you are making POST requests.
        PXLClient.sharedClient.secretKey = "secret"

        PXLPhoto.getPhotoWithId(photoId: "312011951") { newPhoto, _ in
            print("New Photo: \(newPhoto)")
        }
        
//        let albumWithIdentifier = PXLAlbum.albumWithIdentifier(identifier: "4515393")
        let albumWithSKU = PXLAlbum.albumWithSku(sku: 300152)
        albumWithSKU.loadNextPageOfPhotos { photos, error in
            guard error == nil else {
                print("There was an error during the loading \(error)")
                return
            }
//            print("Photos: \(photos)")
            if let firstPhoto = photos?.first {
                print("First photo: \(firstPhoto.id)")
            }
            
            albumWithSKU.loadNextPageOfPhotos { photos, error in
                guard error == nil else {
                    print("There was an error during the loading \(error)")
                    return
                }
//                print("Photos: \(photos)")
                if let firstPhoto = photos?.first {
                    print("First photo: \(firstPhoto.id)")
                }
                albumWithSKU.loadNextPageOfPhotos { photos, error in
                    guard error == nil else {
                        print("There was an error during the loading \(error)")
                        return
                    }
//                    print("Photos: \(photos)")
                    if let firstPhoto = photos?.first {
                        print("First photo: \(firstPhoto.id)")
                    }
                    albumWithSKU.loadNextPageOfPhotos { photos, error in
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
