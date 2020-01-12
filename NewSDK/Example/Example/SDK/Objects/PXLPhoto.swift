//
//  PXLPhoto.swift
//  pixlee_sdk
//
//  Created by Csaba Toth on 2020. 01. 07..
//  Copyright © 2020. BitRaptors. All rights reserved.
//

import Foundation
import MapKit
import Alamofire

enum PXLPhotoSize {
    case thumbnail
    case medium
    case big
}

struct PXLPhoto {
    let id: Int
    let photoTitle: String
    let latitude: Double?
    let longitude: Double?
    let taggedAt: Date?
    let emailAddress: String?
    let instagramFollowers: Int?
    let twitterFollowers: Int?
    let avatarUrl: URL?
    let username: String
    let connectedUserId: Int?
    let source: String?
    let contentType: String?
    let dataFileName: String?
    let mediumUrl: URL?
    let bigUrl: URL?
    let thumbnailUrl: URL?
    let sourceUrl: URL?
    let mediaId: String?
    let existIn: Int?
    let collectTerm: String?
    let albumPhotoId: Int
    let albumId: Int?
    let likeCount: Int?
    let shareCount: Int?
    let actionLink: URL?
    let actionLinkText: String?
    let actionLinkTitle: String?
    let actionLinkPhoto: String?
    let updatedAt: Date?
    let isStarred: Bool?
    let approved: Bool?
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
    var products: [PXLProduct]?
    let cdnSmallUrl: URL?
    let cdnMediumUrl: URL?
    let cdnLargeUrl: URL?
    let cdnOriginalUrl: URL?

    var coordinate: CLLocationCoordinate2D? {
        guard let latitude = self.latitude, let longitude = self.longitude else { return nil }
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    static func photosFromArray(responseArray: [PXLPhotoDTO], inAlbum: PXLAlbum) -> [PXLPhoto] {
        return responseArray.compactMap { (dto) -> PXLPhoto? in

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
                                 products: [],
                                 cdnSmallUrl: URL(string: dto.pixleeCDNPhotos.smallURL),
                                 cdnMediumUrl: URL(string: dto.pixleeCDNPhotos.mediumURL),
                                 cdnLargeUrl: URL(string: dto.pixleeCDNPhotos.largeURL),
                                 cdnOriginalUrl: URL(string: dto.pixleeCDNPhotos.originalURL))

            photo.products = dto.products.map({ (productDto) -> PXLProduct in
                PXLProduct(identifier: productDto.id,
                           photo: photo,
                           linkText: productDto.linkText,
                           link: URL(string: productDto.link),
                           imageUrl: URL(string: productDto.image),
                           title: productDto.title,
                           sku: productDto.sku,
                           productDescription: productDto.productDescription)
            })
            return photo
        }
    }

    static func placeholderPhoto() -> PXLPhoto {
        return PXLPhoto(id: -1,
                        photoTitle: "",
                        latitude: nil,
                        longitude: nil,
                        taggedAt: nil,
                        emailAddress: nil,
                        instagramFollowers: nil,
                        twitterFollowers: nil,
                        avatarUrl: nil,
                        username: "",
                        connectedUserId: nil,
                        source: nil,
                        contentType: nil,
                        dataFileName: nil,
                        mediumUrl: nil,
                        bigUrl: nil,
                        thumbnailUrl: nil,
                        sourceUrl: nil,
                        mediaId: nil,
                        existIn: nil,
                        collectTerm: nil,
                        albumPhotoId: -1,
                        albumId: nil,
                        likeCount: nil,
                        shareCount: nil,
                        actionLink: nil,
                        actionLinkText: nil,
                        actionLinkTitle: nil,
                        actionLinkPhoto: nil,
                        updatedAt: nil,
                        isStarred: nil,
                        approved: nil,
                        archived: nil,
                        isFlagged: nil,
                        album: nil,
                        unreadCount: nil,
                        albumActionLink: nil,
                        title: nil,
                        messaged: nil,
                        hasPermission: nil,
                        awaitingPermission: nil,
                        instUserHasLiked: nil,
                        platformLink: nil,
                        products: nil,
                        cdnSmallUrl: nil,
                        cdnMediumUrl: nil,
                        cdnLargeUrl: nil,
                        cdnOriginalUrl: nil)
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

    static func getPhotoWithId(photoId: String, completionHandler: (PXLPhoto, Error) -> Void) {
        AF.request(PXLClient.sharedClient.apiRequests.getPhotoWithId(id: photoId)).responseDecodable { (response: DataResponse<PXLAlbumNextPageResponse, AFError>) in

            switch response.result {
            case let .success(responseDTO):
                print("Response: \(responseDTO)")
                
            case let .failure(error):
                print("Error: \(error)")
            }
        }
    }
}
