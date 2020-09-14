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
        //self.loadItemsFromCache()
      }
      
      func refreshItems(_ completion:@escaping (_ didLoadNewItems:Bool) -> ()) {
        PlaylistLoader.loadFeed { items in
            
          let didLoadNewItems = items.count > self.items.count
          self.items = items
         // self.saveItemsToCache()
          completion(didLoadNewItems)
        }
      }
    }

    // MARK: Persistance
    extension PlaylistStore {
        
      func saveItemsToCache() {
        NSKeyedArchiver.archiveRootObject(items, toFile: itemsCachePath)
      }
      
      func loadItemsFromCache() {
        if let cachedItems = NSKeyedUnarchiver.unarchiveObject(withFile: itemsCachePath) as? [Item] {
          items = cachedItems
        }
      }
      
      var itemsCachePath: String {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent("playlists")
        return fileURL.path
      }
}
