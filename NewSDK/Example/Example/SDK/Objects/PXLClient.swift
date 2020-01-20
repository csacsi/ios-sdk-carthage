//
//  PXLClient.swift
//  pixlee_sdk
//
//  Created by Csaba Toth on 2020. 01. 07..
//  Copyright © 2020. BitRaptors. All rights reserved.
//

import Alamofire
import Foundation

class PXLClient {
    static var sharedClient = PXLClient()

    let apiRequests = PXLApiRequests()

    private let photoConverter = PXLPhotoConverter(productConverter: PXLProductConverter())
    private var loadingOperations: [String: [Int: DataRequest?]] = [:]

    var apiKey: String? {
        didSet {
            apiRequests.apiKey = apiKey
        }
    }

    var secretKey: String? {
        didSet {
            apiRequests.secretKey = secretKey
        }
    }

    func getPhotoWithPhotoAlbumId(photoAlbumId: String, completionHandler: ((PXLPhoto?, Error?) -> Void)?) -> DataRequest {
        return AF.request(apiRequests.getPhotoWithPhotoAlbumId(photoAlbumId)).responseDecodable { (response: DataResponse<PXLPhotoResponseDTO, AFError>) in

            switch response.result {
            case let .success(responseDTO):
                let photo = self.photoConverter.convertPhotoDTOToPhoto(dto: responseDTO.data)
                completionHandler?(photo, nil)

            case let .failure(error):
                print("Error: \(error)")
                completionHandler?(nil, error)
            }
        }
    }

    func loadNextPageOfPhotosForAlbum(album: PXLAlbum, completionHandler: ((PXLAlbum, [PXLPhoto]?, Error?) -> Void)?) -> DataRequest? {
        if album.hasNextPage {
            let nextPage = album.lastPageFetched == NSNotFound ? 1 : album.lastPageFetched + 1
            if let identifier = album.identifier {
                var requestsForAlbum = loadingOperations[identifier]
                if requestsForAlbum == nil {
                    requestsForAlbum = [:]
                }
                if var requestsForAlbum = requestsForAlbum, requestsForAlbum[nextPage] == nil {
                    print("Loading page \(nextPage)")
                    let request = AF.request(apiRequests.loadNextAlbumPage(album: album)).responseDecodable { (response: DataResponse<PXLAlbumNextPageResponse, AFError>) in

                        let (newAlbum, photos, error) = self.handleAlbumResponse(response, album: album)

                        if let photos = photos, let newAlbum = newAlbum, let completionHandler = completionHandler {
                            print("Page\(nextPage) loaded allPhotos: \(newAlbum.photos.count)")
                            completionHandler(newAlbum, photos, nil)
                        } else if let error = error, let completionHandler = completionHandler {
                            print("Error: \(error)")
                            completionHandler(album, nil, error)
                        }
                    }
                    requestsForAlbum[nextPage] = request
                    loadingOperations[identifier] = requestsForAlbum
                    return request
                } else {
                    completionHandler?(album, nil, nil)
                    return nil
                }
            } else if let sku = album.identifier {
                var requestsForAlbum = loadingOperations[sku]
                if requestsForAlbum == nil {
                    requestsForAlbum = [:]
                }
                if var requestsForAlbum = requestsForAlbum, requestsForAlbum[nextPage] == nil {
                    print("Loading page \(nextPage)")
                    let request = AF.request(apiRequests.loadNextAlbumPageWithSKU(album: album)).responseDecodable { (response: DataResponse<PXLAlbumNextPageResponse, AFError>) in

                        let (newAlbum, photos, error) = self.handleAlbumResponse(response, album: album)

                        if let photos = photos, let newAlbum = newAlbum, let completionHandler = completionHandler {
                            print("Page\(nextPage) loaded allPhotos: \(newAlbum.photos.count)")
                            completionHandler(newAlbum, photos, nil)
                        } else if let error = error, let completionHandler = completionHandler {
                            print("Error: \(error)")
                            completionHandler(album, nil, error)
                        }
                    }
                    requestsForAlbum[nextPage] = request
                    loadingOperations[sku] = requestsForAlbum
                    return request
                } else {
                    completionHandler?(album, nil, nil)
                    return nil
                }
            } else {
                completionHandler?(album, nil, nil)
                return nil
            }
        } else {
            completionHandler?(album, nil, nil)
            return nil
        }
    }

    func handleAlbumResponse(_ response: DataResponse<PXLAlbumNextPageResponse, AFError>, album: PXLAlbum) -> (album: PXLAlbum?, newPhotos: [PXLPhoto]?, error: AFError?) {
        switch response.result {
        case let .success(responseDTO):
            var lastPageFetched = album.lastPageFetched
            if album.lastPageFetched == NSNotFound || responseDTO.page > album.lastPageFetched {
                lastPageFetched = responseDTO.page
            }

            let newPhotos = photoConverter.convertPhotoDTOsToPhotos(photoDtos: responseDTO.data)

            let updatedAlbum = album.handleNewPhotos(newPhotos: newPhotos, newLastPageFetched: lastPageFetched, newHasNextPage: responseDTO.next)

            return (updatedAlbum, newPhotos, nil)
        case let .failure(error):
            print("Error: \(error)")
            return (nil, nil, error)
        }
    }
}
