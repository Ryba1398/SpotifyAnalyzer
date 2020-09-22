//
//  PlaylistStore.swift
//  SpotifyAnalyzer
//
//  Created by Николай Рыбин on 13.09.2020.
//  Copyright © 2020 Николай Рыбин. All rights reserved.
//

import Foundation

final class PlaylistStore: NSObject{
    
      static let sharedStore = PlaylistStore()
      
      var items: [Item] = []
      
      override init() {
        super.init()
        
        print("Download")
        
        self.loadItemsFromCache()
      }
      
      func refreshItems(_ completion:@escaping (_ didLoadNewItems:Bool) -> ()) {
        
        print("refresh")
        
        PlaylistLoader.loadFeed { items in

          let didLoadNewItems = items.count > self.items.count
          self.items = items
            self.saveItemsToCache()
          completion(didLoadNewItems)
        }
      }
    }

    // MARK: Persistance
    extension PlaylistStore {
        
      func saveItemsToCache() {
        
        print("SAVE")
        
         UserDefaults.standard.set(try? PropertyListEncoder().encode(items), forKey: "playlists")
        
    }
      
      func loadItemsFromCache() {
    
        
        
        if let data = UserDefaults.standard.object(forKey: "playlists") as? Data {
            let auth = try? PropertyListDecoder().decode([Item].self, from: data)
            
            items = auth!
        }
        
      }
      
      var itemsCachePath: URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent("playlists")
        return fileURL
      }
}

