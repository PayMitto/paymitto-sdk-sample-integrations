//
//  CreateOAuthTokenResponse.swift
//  ReadyRemitHost
//
//  Created by Franco Cadillo on 3/6/26.
//

import ReadyRemitSDK

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
