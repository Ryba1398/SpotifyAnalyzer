//
//  PlaylistAnalyzer.swift
//  SpotifyAnalyzer
//
//  Created by Николай Рыбин on 28.09.2020.
//  Copyright © 2020 Николай Рыбин. All rights reserved.
//

import Foundation
import Alamofire

class PlaylistAnalyzer {
    

        
    func analyzePlaylist(playlist: Item, _ completion: @escaping (_ commonNumber: Int, _ trackPerYears: [Dictionary<Int, [String]>.Element] ) -> ()){
            
        var tracksGroupedByReleaseYear = [Int: [String]]()
        
        var tracksDictionary = [String: Playlist.Track]()
        
            print("playlist.id - \(playlist.id)")
            
            let url = "https://api.spotify.com/v1/playlists/\(playlist.id)"
            
            request(url, method: .get, headers: ["Authorization": "Bearer \(AuthInfo.accessToken!)"]).responseJSON { response in
                do {
                    
                     let jsonData = response.data!
                    
                    let otvet = try JSONDecoder().decode(Playlist.Info.self, from: jsonData)
                    for item in otvet.tracks.items{
                        
                        
                        let trackURI = self.GetTrackURI(fullURI: item.track.uri)
                        tracksDictionary[trackURI] = item.track
                        
                        let releaseYear = self.GetRealeseYear(of: item.track.album)
                    
                        if(!tracksGroupedByReleaseYear.keys.contains(releaseYear)){
                            var tracks = [String]()
                            tracks.append(trackURI) //item.track.uri      item.track.name
                             tracksGroupedByReleaseYear[releaseYear] = tracks
                        }else{
                            tracksGroupedByReleaseYear[releaseYear]?.append(trackURI)
                        }
                        

                    }
                    
                    let sortedYourArray = tracksGroupedByReleaseYear.sorted(by: {$0.value.count >= $1.value.count})
                    
                    for year in sortedYourArray{
                        //print("\(year.key) - \((Float(year.value.count)/Float(sortedYourArray.count))*100)%")
                        
                        for track in year.value{
                        
                            
                            print("\(track) - \(tracksDictionary[track]!.name) - \(tracksDictionary[track]!.album.name) - \(tracksDictionary[track]!.artists[0].name)")
                        }
                        
                        print("-----------------------------------------")
                    }
                    
                    
                    print(tracksGroupedByReleaseYear.count)
                    
                    print(tracksDictionary.count)
                    
                    completion(tracksDictionary.count, sortedYourArray)
                    
                 } catch {
                    
                    debugPrint(error)
                    
                     print(error.localizedDescription)
                 }
            }
            
        }
        
        private func GetTrackURI(fullURI: String) -> String{
            return  String(fullURI.suffix(22))
        }
        
        private func GetRealeseYear(of album: Playlist.Album) -> Int{
                    
            switch album.releaseDatePrecision{
            case .day:
                return Int(String(album.releaseDate.prefix(4)))!
            case .month:
                return Int(String(album.releaseDate.prefix(4)))!
            case .year:
                return Int(album.releaseDate)!
            }
        }
    
}
