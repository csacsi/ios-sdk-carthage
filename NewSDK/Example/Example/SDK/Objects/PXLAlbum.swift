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
    static let PXLAlbumDefaultPerPage: Int = 20

    let identifier: String?
    let sku: Int?
    let perPage: Int
    let photos: [PXLPhoto]
    let lastPageFetched: Int
    let hasNextPage: Bool
    let sortOptions: PXLAlbumSortOptions?
    let filterOptions: PXLAlbumFilterOptions?

    init(identifier: String? = nil, sku: Int? = nil, perPage: Int = PXLAlbum.PXLAlbumDefaultPerPage, photos: [PXLPhoto] = [PXLPhoto](), lastPageFetched: Int = 0, hasNextPage: Bool = true, sortOptions: PXLAlbumSortOptions? = nil, filterOptions: PXLAlbumFilterOptions? = nil) {
        self.identifier = identifier
        self.sku = sku
        self.perPage = perPage
        self.photos = photos
        self.lastPageFetched = lastPageFetched
        self.hasNextPage = hasNextPage
        self.sortOptions = sortOptions
        self.filterOptions = filterOptions
    }

    func changeIdentifier(newIdentifier: String) -> PXLAlbum {
        return PXLAlbum(identifier: newIdentifier,
                        sku: sku,
                        perPage: PXLAlbum.PXLAlbumDefaultPerPage,
                        photos: [],
                        lastPageFetched: 0,
                        hasNextPage: true,
                        sortOptions: sortOptions,
                        filterOptions: filterOptions)
    }

    func changeSKU(newSKU: Int) -> PXLAlbum {
        return PXLAlbum(identifier: identifier,
                        sku: newSKU,
                        perPage: PXLAlbum.PXLAlbumDefaultPerPage,
                        photos: [],
                        lastPageFetched: NSNotFound,
                        hasNextPage: true,
                        sortOptions: sortOptions,
                        filterOptions: filterOptions)
    }

    func handleNewPhotos(newPhotos: [PXLPhoto], newLastPageFetched: Int, newHasNextPage: Bool) -> PXLAlbum {
        var mutatedPhotos = photos
        mutatedPhotos.append(contentsOf: newPhotos)
        return PXLAlbum(identifier: identifier,
                        sku: sku,
                        perPage: perPage,
                        photos: mutatedPhotos,
                        lastPageFetched: newLastPageFetched,
                        hasNextPage: newHasNextPage,
                        sortOptions: sortOptions,
                        filterOptions: filterOptions)
    }

    func changeSortOptions(newSortOptions: PXLAlbumSortOptions) -> PXLAlbum {
        return PXLAlbum(identifier: identifier,
                        sku: sku,
                        perPage: perPage,
                        photos: [],
                        lastPageFetched: NSNotFound,
                        hasNextPage: true,
                        sortOptions: newSortOptions,
                        filterOptions: filterOptions)
    }

    func changeFilterOptions(newFilterOptions: PXLAlbumFilterOptions) -> PXLAlbum {
        return PXLAlbum(identifier: identifier,
                        sku: sku,
                        perPage: perPage,
                        photos: [],
                        lastPageFetched: NSNotFound,
                        hasNextPage: true,
                        sortOptions: sortOptions,
                        filterOptions: newFilterOptions)
    }

    func changePerPage(newPerPage: Int) -> PXLAlbum {
        return PXLAlbum(identifier: identifier,
                        sku: sku,
                        perPage: newPerPage,
                        photos: [],
                        lastPageFetched: NSNotFound,
                        hasNextPage: true,
                        sortOptions: sortOptions,
                        filterOptions: filterOptions)
    }
}
