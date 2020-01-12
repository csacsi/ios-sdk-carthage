//
//  PXLPhoto.swift
//  pixlee_sdk
//
//  Created by Csaba Toth on 2020. 01. 07..
//  Copyright © 2020. BitRaptors. All rights reserved.
//

import Foundation
import MapKit

enum PXLPhotoSize {
    case thumbnail
    case medium
    case big
}

struct Coordinate: Codable {
    let latitude, longitude: Double
}

extension CLLocationCoordinate2D {
    init(_ coordinate: Coordinate) {
        self = .init(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}

extension Coordinate {
    init(_ coordinate: CLLocationCoordinate2D) {
        self = .init(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}

struct PXLPhoto: Codable {
    let identifier: String
    let photoTitle: String
    let coordinate: Coordinate
    let taggedAt: Date
    let emailAddress: String
    let instagramFollowers: Int
    let twitterFollowers: Int
    let avatarUrl: URL
    let username: String
    let connectedUserId: Int
    let source: String
    let contentType: String
    let dataFileName: String
    let mediumUrl: URL
    let bigUrl: URL
    let thumbnailUrl: URL
    let sourceUrl: URL
    let mediaId: String
    let existIn: Int
    let collectTerm: String
    let albumPhotoId: String
    let albumId: String
    let likeCount: Int
    let shareCount: Int
    let actionLink: URL
    let actionLinkText: String
    let actionLinkTitle: String
    let actionLinkPhoto: String
    let updatedAt: Date
    let isStarred: Bool
    let approved: Bool
    let archived: Bool
    let isFlagged: Bool
    let album: PXLAlbum
    let unreadCount: Int
    let albumActionLink: URL
    let title: String
    let messaged: Bool
    let hasPermission: Bool
    let awaitingPermission: Bool
    let instUserHasLiked: Bool
    let platformLink: URL
    let products: [PXLProduct]
    let cdnSmallUrl: URL
    let cdnMediumUrl: URL
    let cdnLargeUrl: URL
    let cdnOriginalUrl: URL

    func photoUrl(for size: PXLPhotoSize) -> URL {
        switch size {
        case .thumbnail:
            return thumbnailUrl
        case .medium:
            return mediumUrl
        case .big:
            return bigUrl
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
}
