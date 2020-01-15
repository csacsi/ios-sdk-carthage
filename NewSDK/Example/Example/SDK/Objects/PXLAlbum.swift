//
//  PXLAlbum.swift
//  pixlee_sdk
//
//  Created by Csaba Toth on 2020. 01. 07..
//  Copyright © 2020. BitRaptors. All rights reserved.
//

import Alamofire
import Foundation

class PXLAlbum {
    var identifier: String?
    var sku: Int?
    var perPage: Int {
        didSet {
            clearPhotosAndPages()
        }
    }

    var photos: [PXLPhoto]
    var lastPageFetched: Int
    var hasNextPage: Bool
    var sortOptions: PXLAlbumSortOptions? {
        didSet {
            clearPhotosAndPages()
        }
    }

    var filterOptions: PXLAblumFilterOptions? {
        didSet {
            clearPhotosAndPages()
        }
    }

    static let PXLAlbumDefaultPerPage: Int = 20

    convenience init(identifier: String) {
        self.init(perPage: PXLAlbum.PXLAlbumDefaultPerPage,
                  lastPageFetched: NSNotFound,
                  hasNextPage: true,
                  photos: [],
                  loadingOperations: [:])

        self.identifier = identifier
    }

    convenience init(sku: Int) {
        self.init(perPage: PXLAlbum.PXLAlbumDefaultPerPage,
                  lastPageFetched: NSNotFound,
                  hasNextPage: true,
                  photos: [],
                  loadingOperations: [:])
        self.sku = sku
    }

    init(perPage: Int, lastPageFetched: Int, hasNextPage: Bool, photos: [PXLPhoto], loadingOperations: [Int: String]) {
        self.perPage = PXLAlbum.PXLAlbumDefaultPerPage
        self.lastPageFetched = NSNotFound
        self.hasNextPage = true
        self.photos = []
    }

    static func albumWithIdentifier(identifier: String) -> PXLAlbum {
        return PXLAlbum(identifier: identifier)
    }

    static func albumWithSku(sku: Int) -> PXLAlbum {
        return PXLAlbum(sku: sku)
    }

    func clearPhotosAndPages() {
        photos = []
        lastPageFetched = NSNotFound
        hasNextPage = true
    }

    
}
