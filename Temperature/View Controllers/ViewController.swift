//
//  ViewController.swift
//  LoginDemo
//
//  Created by Matthew Guo on 19/12/2020.
//

import UIKit
import AVKit

class ViewController: UIViewController {
    
    //*** VARIABLES ***//
    var videoPlayer:AVPlayer?
    var videoPlayerLayer:AVPlayerLayer?
    
    //*** IB OUTLET ***//
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    //*** View Functions ***//
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElement()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // setup video in the background. setUpVideo() is called here to ensure there is a view for the video to be shown on.
        setUpVideo()
    }
    
    //*** FUNCTIONS ***//
    func setUpVideo() {
        // CWC around 1hr 25 min "https://www.youtube.com/watch?v=1HN7usMROt8&t=828s&ab_channel=CodeWithChris"
        // get path to resource in the bundle. returns an optional string. if can't find resource, will return nil
        let bundlePath = Bundle.main.path(forResource: "DJI_0016", ofType: "MOV")
        
        guard bundlePath != nil else {
            return
        }
        
        //create URL
        let url = URL(fileURLWithPath: bundlePath!)

        //create the video player item
        let item = AVPlayerItem(url: url)

        //create palyer
        videoPlayer = AVPlayer(playerItem: item)

        //create layer
        videoPlayerLayer = AVPlayerLayer(player: videoPlayer!)

        //adjust size and frame.
        videoPlayerLayer?.frame = CGRect(x: -self.view.frame.size.width*1.5, y: 0, width: self.view.frame.size.width*4, height: self.view.frame.size.height)

        view.layer.insertSublayer(videoPlayerLayer!, at: 0)

        //add to view and play video
        videoPlayer?.playImmediately(atRate: 0.6)
        videoPlayer?.play()
    }
    
    func setUpElement() {
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleHollowButton(loginButton)
    }
}

