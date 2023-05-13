//
//  ViewController.swift
//  Image Tracking
//
//  Created by Sadhun Arun on 27/10/22.
//

import UIKit
import RealityKit
import ARKit
import AVKit

class ViewController: UIViewController, ARSessionDelegate{
    
    @IBOutlet var arView: ARView!
    
    var videoPlayer: AVPlayer?
    override func viewDidLoad() {
        super.viewDidLoad()
        startTracking()
        arView.session.delegate = self
    }
    //create tracking images and run session
    func startTracking(){
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "pics", bundle: Bundle.main) else {return}
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages
        configuration.maximumNumberOfTrackedImages = 1
        arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    //creating anchor and plane
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for anchor in anchors{
            //check the anchored image
            guard let imageAnchor = anchor as? ARImageAnchor else {
                return
            }
            let imageModelEntity = createVideoMaterial(imageAnchor: imageAnchor)
            let imgAnchorEntity = AnchorEntity(anchor: imageAnchor)
            imgAnchorEntity.addChild(imageModelEntity)
            arView.scene.addAnchor(imgAnchorEntity)
        }
        
        func createVideoMaterial(imageAnchor: ARImageAnchor) -> ModelEntity{
            //path
            let path = Bundle.main.path(forResource: "photosynthesis", ofType: "mp4")
            //videoURL
            let url = URL(filePath: path!)
            //playerItem
            let playerItem = AVPlayerItem(url: url)
            //videoplayer
            videoPlayer = AVPlayer(playerItem: playerItem)
            //viddeoMaterial
            let videoMaterial = VideoMaterial(avPlayer: videoPlayer!)
            //modelEntity
            let width = Float(imageAnchor.referenceImage.physicalSize.width)
            let depth = Float(imageAnchor.referenceImage.physicalSize.height)
            let videoPlaneEntity = ModelEntity(mesh: .generatePlane(width: width , depth: depth), materials: [videoMaterial])
            
            return videoPlaneEntity
        }
    }
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for anchor in anchors{
            guard let imageAnchor = anchor as? ARImageAnchor else {return}
            if imageAnchor.isTracked{
                videoPlayer?.play()
            }
            else {
                videoPlayer?.pause()
            }
        }
    }
    @objc func Play(sender: UIButton){
        videoPlayer?.play()
    }
    @objc func Stop(sender: UIButton){
        videoPlayer?.pause()
    }
}
