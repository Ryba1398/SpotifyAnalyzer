//
//  ConstantInfo.swift
//  SpotifyAnalyzer
//
//  Created by Николай Рыбин on 18.08.2020.
//  Copyright © 2020 Николай Рыбин. All rights reserved.
//

import Foundation

struct ConstantInfo {
    static let SpotifyClientID = "b225811b88cf4fee81a761a91aa0ad6e"
    static let ClientSecret = "e66548f26ad6452481e5a8ad0f42571d"
    
    static let redirectURI =  "spotify-analyzer://spotify-login-callback" // URL(string: "spotify-analyzer://")
    static let sessionKey = "spotifySessionKey"
    
    
    
}

struct AuthInfo: Decodable {

    static var accessToken: String?
    static var refreshToken: String?

}

struct SessionInfo: Codable {
    
    var status: Bool?
    var accessToken: String?
    var refreshToken: String?
    
    init( status: Bool, accessToken: String, refreshToken: String) {
        self.status = status
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}


//extension URL {
//    static var recommendations: URL {
//        makeForEndpoint("recommendations")
//    }
//
//    static func article(withID id: Article.ID) -> URL {
//        makeForEndpoint("articles/\(id)")
//    }
//}
//
//private extension URL {
//    static func makeForEndpoint(_ endpoint: String) -> URL {
//        URL(string: "https://api.myapp.com/\(endpoint)")!
//    }
//}

//"https://api.spotify.com/v1/me/playlists"

//"https://accounts.spotify.com/api/token"
