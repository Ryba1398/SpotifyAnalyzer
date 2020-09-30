//
//  PlaylistInfoViewController.swift
//  SpotifyAnalyzer
//
//  Created by Николай Рыбин on 26.09.2020.
//  Copyright © 2020 Николай Рыбин. All rights reserved.
//

import UIKit
import Then
import TinyConstraints

class PlaylistInfoViewController: UIViewController, UIGestureRecognizerDelegate  {
    
    let analyzer = PlaylistAnalyzer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.view.backgroundColor = UIColor(red: 18/255, green: 18/255, blue: 18/255, alpha: 1.0)
    }
    
    func setPlaylistInfo(playlist: Item){
        
        analyzer.analyzePlaylist(playlist: playlist) { commonNumber, tracksPerYears in
            
            print("draw --------")
            
            let circlePath = UIBezierPath(ovalIn: CGRect(x: 175, y: 200, width: 150, height: 150))
            var segments: [CAShapeLayer] = []
            
            var i = 0
            
            
            var count : CGFloat = 0.0
            
            print(tracksPerYears.count)
            
            var previusPartEnd : CGFloat = 0
            
            for elem in tracksPerYears {
                
                
                let circleLayer = CAShapeLayer()
                circleLayer.path = circlePath.cgPath
                
                let segmentAngle: CGFloat = CGFloat(elem.value.count) / CGFloat(commonNumber)
                
                print(segmentAngle)
                
                count+=segmentAngle
                
                // start angle is number of segments * the segment angle
                circleLayer.strokeStart = previusPartEnd
                
                // end angle is the start plus one segment, minus a little to make a gap
                // you'll have to play with this value to get it to look right at the size you need
                let gapSize: CGFloat = 0.004
                circleLayer.strokeEnd = circleLayer.strokeStart + segmentAngle - gapSize
                
                circleLayer.lineWidth = 15
                
                circleLayer.strokeColor = UIColor.random().cgColor
                circleLayer.fillColor = UIColor.clear.cgColor
                
                // add the segment to the segments array and to the view
                segments.insert(circleLayer, at: i)
                self.view.layer.addSublayer(segments[i])
                
                previusPartEnd = circleLayer.strokeEnd + gapSize
                
                i+=1
            }
            
            print(count)
            
        }
        
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(
            red:   CGFloat(arc4random()) / CGFloat(UInt32.max),
            green: CGFloat(arc4random()) / CGFloat(UInt32.max),
            blue:  CGFloat(arc4random()) / CGFloat(UInt32.max),
            alpha: 1.0
        )
    }
}
