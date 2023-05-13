//
//  VideoViewController.swift
//  Button direct video
//
//  Created by Sadhun Arun on 31/10/22.
//

import UIKit
import AVKit
import ARKit
import AVFoundation

class VideoViewController: UIViewController {

    @IBOutlet weak var myView: UIView!
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    var playerController: AVPlayerViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        videoPlayer()
    }
    func videoPlayer(){
        guard let url = Bundle.main.url(forResource: "photosynthesis", withExtension: "mp4")
        else {
            debugPrint("no video file found !")
            return
        }
//        player = AVPlayer(url: url)
//        playerLayer = AVPlayerLayer(player: player)
//        playerLayer.videoGravity = .resize
//        myView.layer.addSublayer(playerLayer)
        player = AVPlayer(url: url)
        playerController = AVPlayerViewController()
        playerController.player = player
        playerController.view.frame = myView.bounds
        self.myView.addSubview(playerController.view)
        
        
    }
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        playerLayer.frame = myView.bounds
//
//    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player.play()
    }
}
