//
//  PXLApiRequests.swift
//  pixlee_sdk
//
//  Created by Csaba Toth on 2020. 01. 07..
//  Copyright © 2020. BitRaptors. All rights reserved.
//

import Alamofire
import Foundation

class PXLApiRequests {
    private let baseURL: String = "https://distillery.pixlee.com/api/v2/"

    var apiKey: String?
    var secretKey: String?

    private func headers(headers: [String: String], parameters: [String: Any]) -> [String: String] {
        var httpHeaders = [String: String]()

        assert(apiKey != nil, "Your Pixlee API Key must be set before making API calls.")

        var newParameters = parameters

        if let apiKey = apiKey {
            newParameters["API_KEY"] = "\(apiKey)"
        }

        httpHeaders["Content-Type"] = "application/json"
        httpHeaders["Accept"] = "application/json"

        assert(secretKey != nil, "Your Pixlee Secret Key must be set before making API calls.")
        if let secret = self.secretKey {
            if let parametersData = try? JSONSerialization.data(withJSONObject: newParameters, options: []), let jsonParameters = String(data: parametersData, encoding: String.Encoding.utf8) {
                let signedParameters = jsonParameters.hmac(algorithm: .SHA1, key: secret)
                print("Converted hex: \(signedParameters)")

                let timestamp = Date().timeIntervalSinceNow
//                let hmac = jsonParameters.digest(.sha1, key: secret)
                httpHeaders["Signature"] = signedParameters
                httpHeaders["X-Authorization-Timestamp"] = "\(timestamp)"
            }
        }

        return httpHeaders
    }
}

extension PXLApiRequests {
    private static func urlRequest(_ method: Alamofire.HTTPMethod,
                                   _ url: URLConvertible,
                                   parameters: [String: Any]? = nil,
                                   encoding: ParameterEncoding = URLEncoding.default,
                                   headers: [String: String]? = nil)
        throws -> Foundation.URLRequest {
        var mutableURLRequest = Foundation.URLRequest(url: try url.asURL())
        mutableURLRequest.httpMethod = method.rawValue

        if let headers = headers {
            for (headerField, headerValue) in headers {
                mutableURLRequest.setValue(headerValue, forHTTPHeaderField: headerField)
            }
        }

        if let parameters = parameters {
            mutableURLRequest = try encoding.encode(mutableURLRequest, with: parameters)
        }

        return mutableURLRequest
    }
}
