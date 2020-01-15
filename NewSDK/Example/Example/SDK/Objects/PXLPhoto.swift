//
//  PXLPhoto.swift
//  pixlee_sdk
//
//  Created by Csaba Toth on 2020. 01. 07..
//  Copyright © 2020. BitRaptors. All rights reserved.
//

import Alamofire
import Foundation
import MapKit

enum PXLPhotoSize {
    case thumbnail
    case medium
    case big
}

struct PXLPhoto {
    let id: Int
    let photoTitle: String?
    let latitude: Double?
    let longitude: Double?
    let taggedAt: Date?
    let emailAddress: String?
    let instagramFollowers: Int?
    let twitterFollowers: Int?
    let avatarUrl: URL?
    let username: String
    let connectedUserId: Int
    let source: String
    let contentType: String
    let dataFileName: String?
    let mediumUrl: URL?
    let bigUrl: URL?
    let thumbnailUrl: URL?
    let sourceUrl: URL?
    let mediaId: String?
    let existIn: Int?
    let collectTerm: String?
    let albumPhotoId: Int
    let albumId: Int
    let likeCount: Int?
    let shareCount: Int?
    let actionLink: URL?
    let actionLinkText: String?
    let actionLinkTitle: String?
    let actionLinkPhoto: String?
    let updatedAt: Date?
    let isStarred: Bool?
    let approved: Bool
    let archived: Bool?
    let isFlagged: Bool?
    let album: PXLAlbum?
    let unreadCount: Int?
    let albumActionLink: URL?
    let title: String?
    let messaged: Bool?
    let hasPermission: Bool?
    let awaitingPermission: Bool?
    let instUserHasLiked: Bool?
    let platformLink: URL?
    let products: [PXLProduct]?
    let cdnSmallUrl: URL?
    let cdnMediumUrl: URL?
    let cdnLargeUrl: URL?
    let cdnOriginalUrl: URL?

    var coordinate: CLLocationCoordinate2D? {
        guard let latitude = self.latitude, let longitude = self.longitude else { return nil }
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    public func setProducts(newProducts: [PXLProduct]) -> PXLPhoto {
        return PXLPhoto(id: id,
                        photoTitle: photoTitle,
                        latitude: latitude,
                        longitude: longitude,
                        taggedAt: taggedAt,
                        emailAddress: emailAddress,
                        instagramFollowers: instagramFollowers,
                        twitterFollowers: twitterFollowers,
                        avatarUrl: avatarUrl,
                        username: username,
                        connectedUserId: connectedUserId,
                        source: source,
                        contentType: contentType,
                        dataFileName: dataFileName,
                        mediumUrl: mediumUrl,
                        bigUrl: bigUrl,
                        thumbnailUrl: thumbnailUrl,
                        sourceUrl: sourceUrl,
                        mediaId: mediaId,
                        existIn: existIn,
                        collectTerm: collectTerm,
                        albumPhotoId: albumPhotoId,
                        albumId: albumId,
                        likeCount: likeCount,
                        shareCount: shareCount,
                        actionLink: actionLink,
                        actionLinkText: actionLinkText,
                        actionLinkTitle: actionLinkTitle,
                        actionLinkPhoto: actionLinkPhoto,
                        updatedAt: updatedAt,
                        isStarred: isStarred,
                        approved: approved,
                        archived: archived,
                        isFlagged: isFlagged,
                        album: album,
                        unreadCount: unreadCount,
                        albumActionLink: albumActionLink,
                        title: title,
                        messaged: messaged,
                        hasPermission: hasPermission,
                        awaitingPermission: awaitingPermission,
                        instUserHasLiked: instUserHasLiked,
                        platformLink: platformLink,
                        products: newProducts,
                        cdnSmallUrl: cdnSmallUrl,
                        cdnMediumUrl: cdnMediumUrl,
                        cdnLargeUrl: cdnLargeUrl,
                        cdnOriginalUrl: cdnOriginalUrl)
    }

    static func photoFromDTO(dto: PXLPhotoDTO, inAlbum: PXLAlbum?) -> PXLPhoto {
        var photo = PXLPhoto(id: dto.id,
                             photoTitle: dto.photoTitle ?? "",
                             latitude: dto.latitude,
                             longitude: dto.longitude,
                             taggedAt: Date(timeIntervalSince1970: TimeInterval(dto.taggedAt)),
                             emailAddress: dto.emailAddress,
                             instagramFollowers: dto.instagramFollowers,
                             twitterFollowers: dto.twitterFollowers,
                             avatarUrl: dto.avatarURL != nil ? URL(string: dto.avatarURL!) : nil,
                             username: dto.userName,
                             connectedUserId: dto.connectedUserID,
                             source: dto.source,
                             contentType: dto.contentType,
                             dataFileName: dto.dataFileName,
                             mediumUrl: dto.mediumURL != nil ? URL(string: dto.mediumURL!) : nil,
                             bigUrl: dto.bigURL != nil ? URL(string: dto.bigURL!) : nil,
                             thumbnailUrl: dto.thumbnailURL != nil ? URL(string: dto.thumbnailURL!) : nil,
                             sourceUrl: URL(string: dto.sourceURL),
                             mediaId: dto.mediaID,
                             existIn: dto.existIn,
                             collectTerm: dto.collectTerm,
                             albumPhotoId: dto.albumPhotoID,
                             albumId: dto.albumID,
                             likeCount: dto.likeCount,
                             shareCount: dto.shareCount,
                             actionLink: dto.actionLink != nil ? URL(string: dto.actionLink!) : nil,
                             actionLinkText: dto.actionLinkText,
                             actionLinkTitle: dto.actionLinkText,
                             actionLinkPhoto: dto.actionLinkPhoto,
                             updatedAt: Date(timeIntervalSince1970: TimeInterval(dto.updatedAt)),
                             isStarred: dto.isStarred,
                             approved: dto.approved,
                             archived: dto.archived,
                             isFlagged: dto.isFlagged,
                             album: inAlbum,
                             unreadCount: dto.unreadCount,
                             albumActionLink: nil,
                             title: dto.title,
                             messaged: dto.messaged,
                             hasPermission: dto.hasPermission,
                             awaitingPermission: dto.awaitingPermission,
                             instUserHasLiked: dto.socialUserHasLiked,
                             platformLink: URL(string: dto.platformLink),
                             products: nil,
                             cdnSmallUrl: URL(string: dto.pixleeCDNPhotos.smallURL),
                             cdnMediumUrl: URL(string: dto.pixleeCDNPhotos.mediumURL),
                             cdnLargeUrl: URL(string: dto.pixleeCDNPhotos.largeURL),
                             cdnOriginalUrl: URL(string: dto.pixleeCDNPhotos.originalURL))

        let products = dto.products.map({ (productDto) -> PXLProduct in
            PXLProduct(identifier: productDto.id,
                       photo: photo,
                       linkText: productDto.linkText,
                       link: URL(string: productDto.link),
                       imageUrl: URL(string: productDto.image),
                       title: productDto.title,
                       sku: productDto.sku,
                       productDescription: productDto.productDescription)
        })
        return photo.setProducts(newProducts: products)
    }

    static func photosFromArray(responseArray: [PXLPhotoDTO], inAlbum: PXLAlbum) -> [PXLPhoto] {
        return responseArray.compactMap { (dto) -> PXLPhoto? in
            PXLPhoto.photoFromDTO(dto: dto, inAlbum: inAlbum)
        }
    }

    func photoUrl(for size: PXLPhotoSize) -> URL? {
        switch size {
        case .thumbnail:
            return cdnSmallUrl
        case .medium:
            return cdnMediumUrl
        case .big:
            return cdnLargeUrl
        }
    }

    var sourceIconImage: UIImage? {
        switch source {
        case "instagram":
            return UIImage(named: "instagram", in: Bundle(identifier: "Pixlee.pixlee-sdk"), with: nil)
        case "facebook":
            return UIImage(named: "facebook", in: Bundle(identifier: "Pixlee.pixlee-sdk"), with: nil)
        case "pinterest":
            return UIImage(named: "pinterest", in: Bundle(identifier: "Pixlee.pixlee-sdk"), with: nil)
        case "tumblr":
            return UIImage(named: "tumblr", in: Bundle(identifier: "Pixlee.pixlee-sdk"), with: nil)
        case "twitter":
            return UIImage(named: "twitter", in: Bundle(identifier: "Pixlee.pixlee-sdk"), with: nil)
        case "vine":
            return UIImage(named: "vine", in: Bundle(identifier: "Pixlee.pixlee-sdk"), with: nil)
        default:
            return nil
        }
    }

    static func getPhotoWithId(photoId: String, completionHandler: ((PXLPhoto?, Error?) -> Void)?) -> DataRequest {
        return AF.request(PXLClient.sharedClient.apiRequests.getPhotoWithId(id: photoId)).responseDecodable { (response: DataResponse<PXLPhotoResponseDTO, AFError>) in

            switch response.result {
            case let .success(responseDTO):
                print("Response: \(responseDTO)")
                let photo = PXLPhoto.photoFromDTO(dto: responseDTO.data, inAlbum: nil)
                completionHandler?(photo, nil)

            case let .failure(error):
                print("Error: \(error)")
                completionHandler?(nil, error)
            }
        }
    }
}
