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

    private var loadingOperations: [Int: DataRequest?]

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
        self.loadingOperations = [:]
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
        loadingOperations = [:]
    }

    func loadNextPageOfPhotos(completionHandler: (([PXLPhoto]?, Error?) -> Void)?) -> DataRequest? {
        if hasNextPage {
            let nextPage = lastPageFetched == NSNotFound ? 1 : lastPageFetched + 1
            if loadingOperations[nextPage] == nil {
                print("Loading page \(nextPage)")
                var req: URLRequest
                if identifier != nil {
                    req = PXLClient.sharedClient.apiRequests.loadNextAlbumPage(album: self)
                } else if sku != nil {
                    req = PXLClient.sharedClient.apiRequests.loadNextAlbumPageWithSKU(album: self)
                } else {
                    completionHandler?(nil, nil)
                    return nil
                }

                let request = AF.request(req).responseDecodable { (response: DataResponse<PXLAlbumNextPageResponse, AFError>) in

                    switch response.result {
                    case let .success(responseDTO):
                        if self.lastPageFetched == NSNotFound || responseDTO.page > self.lastPageFetched {
                            self.lastPageFetched = responseDTO.page
                        }
                        self.hasNextPage = responseDTO.next

                        let newPhotos = PXLPhoto.photosFromArray(responseArray: responseDTO.data, inAlbum: self)
                        self.photos.append(contentsOf: newPhotos)

                        self.loadingOperations[nextPage] = nil
                        print("Page\(nextPage) loaded allPhotos: \(self.photos.count)")
                        completionHandler?(newPhotos, nil)
                    case let .failure(error):
                        print("Error: \(error)")
                        completionHandler?(nil, error)
                    }
                }
                loadingOperations[nextPage] = request
                return request
            } else {
                completionHandler?(nil, nil)
                return nil
            }
        } else {
            completionHandler?(nil, nil)
            return nil
        }
    }
}
