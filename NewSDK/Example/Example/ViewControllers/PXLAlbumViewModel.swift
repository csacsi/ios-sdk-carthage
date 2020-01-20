//
//  PXLAlbumViewModel.swift
//  Example
//
//  Created by Csaba Toth on 2020. 01. 17..
//  Copyright © 2020. Pixlee. All rights reserved.
//

import Foundation

struct PXLAlbumViewModel {
    var album: PXLAlbum

    var photos: [PXLPhoto] {
        album.photos
    }
}
