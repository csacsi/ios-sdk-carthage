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

    func getPhotoWithId(photoId: String, completionHandler: ((PXLPhoto?, Error?) -> Void)?) -> DataRequest {
        return AF.request(apiRequests.getPhotoWithId(id: photoId)).responseDecodable { (response: DataResponse<PXLPhotoResponseDTO, AFError>) in

            switch response.result {
            case let .success(responseDTO):
                print("Response: \(responseDTO)")
                let photo = self.photoConverter.convertPhotoDTOToPhoto(dto: responseDTO.data, inAlbum: nil)
                completionHandler?(photo, nil)

            case let .failure(error):
                print("Error: \(error)")
                completionHandler?(nil, error)
            }
        }
    }

    func loadNextPageOfPhotosForAlbum(album: PXLAlbum, completionHandler: (([PXLPhoto]?, Error?) -> Void)?) -> DataRequest? {
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

                        let (photos, error) = self.handleAlbumResponse(response, album: album)

                        if let photos = photos {
                            print("Page\(nextPage) loaded allPhotos: \(album.photos.count)")
                            completionHandler?(photos, nil)
                        } else if let error = error {
                            print("Error: \(error)")
                            completionHandler?(nil, error)
                        }
                    }
                    requestsForAlbum[nextPage] = request
                    loadingOperations[identifier] = requestsForAlbum
                    return request
                } else {
                    completionHandler?(nil, nil)
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

                        let (photos, error) = self.handleAlbumResponse(response, album: album)

                        if let photos = photos {
                            print("Page\(nextPage) loaded allPhotos: \(album.photos.count)")
                            completionHandler?(photos, nil)
                        } else if let error = error {
                            print("Error: \(error)")
                            completionHandler?(nil, error)
                        }
                    }
                    requestsForAlbum[nextPage] = request
                    loadingOperations[sku] = requestsForAlbum
                    return request
                } else {
                    completionHandler?(nil, nil)
                    return nil
                }
            } else {
                completionHandler?(nil, nil)
                return nil
            }
        } else {
            completionHandler?(nil, nil)
            return nil
        }
    }

    func handleAlbumResponse(_ response: DataResponse<PXLAlbumNextPageResponse, AFError>, album: PXLAlbum) -> (photos: [PXLPhoto]?, error: AFError?) {
        switch response.result {
        case let .success(responseDTO):
            if album.lastPageFetched == NSNotFound || responseDTO.page > album.lastPageFetched {
                album.lastPageFetched = responseDTO.page
            }
            album.hasNextPage = responseDTO.next

            let newPhotos = photoConverter.convertPhotoDTOsToPhotos(photoDtos: responseDTO.data, inAlbum: album)
            album.photos.append(contentsOf: newPhotos)

            return (newPhotos, nil)
        case let .failure(error):
            print("Error: \(error)")
            return (nil, error)
        }
    }
}
