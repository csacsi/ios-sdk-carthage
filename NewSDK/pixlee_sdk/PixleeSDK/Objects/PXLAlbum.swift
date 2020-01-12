//
//  PXLAlbum.swift
//  pixlee_sdk
//
//  Created by Csaba Toth on 2020. 01. 07..
//  Copyright © 2020. BitRaptors. All rights reserved.
//

import Foundation

struct PXLAlbum: Codable {
    let identifier: String
    let sku: String
    let perPage: Int
    let photos: [PXLPhoto]
    let lastPageFetched: Int
    let hasNextPage: Bool
    let sortOptions: PXLAlbumSortOptions
    let filterOptions: PXLAblumFilterOptions
}
