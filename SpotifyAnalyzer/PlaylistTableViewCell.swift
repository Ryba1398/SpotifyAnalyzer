//
//  PlaylistTableViewCell.swift
//  SpotifyAnalyzer
//
//  Created by Николай Рыбин on 12.09.2020.
//  Copyright © 2020 Николай Рыбин. All rights reserved.
//

import UIKit
import Then
import TinyConstraints
import  Alamofire

class PlaylistTableViewCell: UITableViewCell {

    let playlistCoverImage = UIImageView().then {
        $0.image = #imageLiteral(resourceName: "Дизайн без названия")
    }
    
    let playlistNameLabel = UILabel().then {
        $0.textColor = .white
        $0.text = "Любимые треки"
        $0.font = UIFont.boldSystemFont(ofSize: 18)
    }
    
    let playlistAuthorLabel = UILabel().then {
        
        $0.textColor = UIColor(red: 188/255, green: 188/255, blue: 188/255, alpha: 1.0)
        $0.text = "870 треков"
        $0.font = UIFont.systemFont(ofSize: 14)
        
    }
    
    public func initCell(playlist: Item) {
        
        print("initializing playlist's cell")
        
        //contentView.translatesAutoresizingMaskIntoConstraints = true
        
        
        backgroundColor = UIColor(red: 18/255, green: 18/255, blue: 18/255, alpha: 1.0)
        
        
        contentView.height(100 )
        
        contentView.addSubview(playlistCoverImage)
        contentView.addSubview(playlistNameLabel)
        contentView.addSubview(playlistAuthorLabel)
        
        //playlistCoverImage.centerY(to: self.contentView)
        
        playlistCoverImage.top(to: contentView, offset: 10)
        playlistCoverImage.left(to: contentView, offset: 15)
        playlistCoverImage.height(80)
        playlistCoverImage.width(80)
        
        playlistNameLabel.top(to: contentView, offset:  contentView.frame.height - 12)
        playlistNameLabel.leftToRight(of: playlistCoverImage, offset: 10)
        
        playlistAuthorLabel.top(to: contentView, offset: contentView.frame.height + 12)
        playlistAuthorLabel.leftToRight(of: playlistCoverImage, offset: 10)
        
        
        playlistNameLabel.text = playlist.name
        playlistAuthorLabel.text = "\(playlist.tracks.total) треков"
        
        if(playlist.images.count != 0){
            let imageHref = playlist.images[0].url
            
            guard let url = URL(string: imageHref) else { return }

              
            request(url, method: .get, headers: nil).responseJSON { response in
                  do {

                    DispatchQueue.main.async() { [weak self] in
                        self?.playlistCoverImage.image = UIImage(data: response.data!)
                    }
                    
                   } catch {
                       
                       print(error.localizedDescription)
                   }
              }
            
           
        }
        


    }
}
