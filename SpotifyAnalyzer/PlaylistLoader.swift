
//
//  PlaylistLoader.swift
//  SpotifyAnalyzer
//
//  Created by Николай Рыбин on 12.09.2020.
//  Copyright © 2020 Николай Рыбин. All rights reserved.
//

import Foundation
import Alamofire

class PlaylistLoader {
    
    

    static let FeedURL = "https://api.spotify.com/v1/me/playlists"

    static func loadFeed(_ completion: @escaping ([Item]) -> ()) {
        
        guard URL(string: FeedURL) != nil else { return }

        
        print("LOAD")
        
        request(FeedURL, method: .get, headers: ["Authorization": "Bearer \(AuthInfo.accessToken!)"]).responseJSON { response in
            do {
                
                 print("before before before before")
                
                 let jsonData = response.data!
                
                let otvet = try JSONDecoder().decode(Playlists.self, from: jsonData)
                
                print("before")
                
                for item in otvet.items{
                    print(item.name)
                }
                
                 print("after")
                
                completion(otvet.items)
                
             } catch {
                 
                 print(error.localizedDescription)
             }
        }
      
    }
}
