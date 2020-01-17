//
//  ViewController.swift
//  Example
//
//  Created by Csaba Toth on 2020. 01. 08..
//  Copyright © 2020. Pixlee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let album = PXLAlbum.albumWithIdentifier(identifier: "4515393")

    override func viewDidLoad() {
        super.viewDidLoad()

        //        #warning Replace with your Pixlee API key.
        PXLClient.sharedClient.apiKey = "Hz7VLPHt7ow-oY992rJi"
        //        #warning Replace with your Secret Key if you are making POST requests.
        PXLClient.sharedClient.secretKey = "secret"

        // Get one photo example
        _ = PXLClient.sharedClient.getPhotoWithPhotoAlbumId(photoAlbumId: "299469263") { newPhoto, error in
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
    }

    override func viewDidAppear(_ animated: Bool) {
        let albumVC = PXLAlbumViewController(nibName: "PXLAlbumViewController", bundle: nil)
        albumVC.viewModel = album
        showViewController(VC: albumVC)
    }

    func showViewController(VC: UIViewController) {
        VC.willMove(toParent: self)
        addChild(VC)
        VC.view.frame = view.bounds
        view.addSubview(VC.view)
        VC.didMove(toParent: self)
    }
}
