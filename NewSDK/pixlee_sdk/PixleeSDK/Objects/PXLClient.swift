//
//  PXLClient.swift
//  pixlee_sdk
//
//  Created by Csaba Toth on 2020. 01. 07..
//  Copyright © 2020. BitRaptors. All rights reserved.
//

import Foundation

class PXLClient {
    static let sharedClient = PXLClient()

    let apiRequests = PXLApiRequests()

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
}
