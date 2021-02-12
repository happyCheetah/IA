//
//  VideoPlayerLooped.swift
//  LoginDemo
//
//  Created by Matthew Guo on 24/12/2020.
//

import Foundation
import AVKit

class VideoPlayerLooped {
    /* code below comes from: https://codewithchris.com/source-code/#firebaseauth 'Firebase Login Page' project */
    
    public var videoPlayer:AVQueuePlayer?
    public var videoPlayerLayer:AVPlayerLayer?
    var playerLooper: NSObject?
    var queuePlayer: AVQueuePlayer?

    func playVideo(fileName:String, inView:UIView){

        if let path = Bundle.main.path(forResource: fileName, ofType: "MOV") {

            let url = URL(fileURLWithPath: path)
            let playerItem = AVPlayerItem(url: url as URL)

            videoPlayer = AVQueuePlayer(items: [playerItem])
            playerLooper = AVPlayerLooper(player: videoPlayer!, templateItem: playerItem)

            videoPlayerLayer = AVPlayerLayer(player: videoPlayer)
            videoPlayerLayer!.frame = inView.bounds
            videoPlayerLayer!.videoGravity = AVLayerVideoGravity.resizeAspectFill

            inView.layer.addSublayer(videoPlayerLayer!)

            videoPlayer?.play()
        }
    }

    func remove() {
        videoPlayerLayer?.removeFromSuperlayer()
    }
}
