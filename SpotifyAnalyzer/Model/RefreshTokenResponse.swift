//
//  RefreshTokenResponse.swift
//  SpotifyAnalyzer
//
//  Created by Николай Рыбин on 20.09.2020.
//  Copyright © 2020 Николай Рыбин. All rights reserved.
//

import Foundation

struct NewAccessToken: Codable {
    let accessToken, tokenType: String
    let expiresIn: Int
    let refreshToken, scope: String?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
        case scope
    }
}
