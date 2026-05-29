//
//  CreateOAuthTokenResponse.swift
//  PayMittoHost
//
//  Created by Matthew Mohrman on 10/23/25.
//

import PayMittoSDK

struct CreateOAuthTokenResponse: Decodable {
    let accessToken: String
    let expiresIn: Int
    let scope: String
    let tokenType: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case scope
        case tokenType = "token_type"
    }
}

extension CreateOAuthTokenResponse: AccessTokenDetails { }
