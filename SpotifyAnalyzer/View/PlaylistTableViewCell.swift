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
        $0.image = UIImage(named: "emptyPlaylistCover.jpg")
        $0.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1.0)
    }
    
    let playlistNameLabel = UILabel().then {
        $0.textColor = .white
        $0.text = "Любимые треки"
        $0.font = UIFont.boldSystemFont(ofSize: 18)
    }
    
    let playlistTrackNumberLabel = UILabel().then {
        $0.textColor = UIColor(red: 188/255, green: 188/255, blue: 188/255, alpha: 1.0)
        $0.text = "870 треков"
        $0.font = UIFont.systemFont(ofSize: 14)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        ConfigureSelectStyle()
        SetConstraints()
     }
    
    
     required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    private func ConfigureSelectStyle(){
        let view = UIView()
        view.backgroundColor = UIColor(red: 10/255, green: 10/255, blue: 10/255, alpha: 1.0)
        self.selectedBackgroundView = view
    }
    
    private func SetConstraints(){
            backgroundColor = UIColor(red: 18/255, green: 18/255, blue: 18/255, alpha: 1.0)
        
            contentView.addSubview(playlistCoverImage)
            contentView.addSubview(playlistNameLabel)
            contentView.addSubview(playlistTrackNumberLabel)

            playlistCoverImage.top(to: self.contentView, offset: 10)
            playlistCoverImage.bottom(to: self.contentView, offset: -10)
            playlistCoverImage.left(to: contentView, offset: 15)
            playlistCoverImage.height(80)
            playlistCoverImage.aspectRatio(1)
            
            playlistNameLabel.centerY(to: self.contentView, offset: -12)
            playlistNameLabel.leftToRight(of: playlistCoverImage, offset: 10)

            playlistTrackNumberLabel.centerY(to: self.contentView, offset: 12)
            playlistTrackNumberLabel.leftToRight(of: playlistCoverImage, offset: 10)
    }
    
    public func initCell(playlist: Item) {
        playlistNameLabel.text = playlist.name
        playlistTrackNumberLabel.text = generateTracksNumberString(number: playlist.tracks.total)
        
        if(playlist.images.count != 0){
        
            let url = URL(string: playlist.images[0].url)!
            
            request(url, method: .get, headers: nil).responseJSON { response in
                DispatchQueue.main.async() { [weak self] in
                      self?.playlistCoverImage.image = UIImage(data: response.data!)
                  }
              }
        }else{
            self.playlistCoverImage.image = UIImage(named: "emptyPlaylistCover.jpg")
        }
    }
    
    private func generateTracksNumberString(number: Int) -> String{
        if((number%10 == 2 || number%10 == 3 || number%10 == 4) && number != 12 && number != 13 && number != 14){
            return "\(number) трека"
        }
        else  if(number%10 == 1 && number != 11){
            return "\(number) трек"
        }else{
            return "\(number) треков"
        }
    }
}
