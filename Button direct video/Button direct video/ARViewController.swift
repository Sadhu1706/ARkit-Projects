//
//  ViewController.swift
//  Button direct video
//
//  Created by Sadhun Arun on 31/10/22.
//

import UIKit
import RealityKit
import AVKit
import ARKit

class ARViewController: UIViewController , ARSessionDelegate{
    
    @IBOutlet var myView: UIView!
    @IBOutlet var arView: ARView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //start image tracking
        startTracking()
        //run delegate
        arView.session.delegate = self
    }
    func startTracking(){
        guard let referenceImage = ARReferenceImage.referenceImages(inGroupNamed: "pics", bundle: Bundle.main)
        else {
            debugPrint("No images found !")
            return
        }
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImage
        configuration.maximumNumberOfTrackedImages = 1
        arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    internal func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for anchor in anchors{
            guard let imageAnchor = anchor as? ARImageAnchor
            else {
                debugPrint("no anchor found !")
                return
            }
            if imageAnchor.isTracked {
                createTapGesture()
            }
            else {
                arView.isUserInteractionEnabled = false
            }
        }
    }
    func createTapGesture(){
        var tapGesture = UITapGestureRecognizer()
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(playVideo))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        arView.addGestureRecognizer(tapGesture)
        arView.isUserInteractionEnabled = true
    }
    @IBAction func playVideo(_ sender: Any){
        self.performSegue(withIdentifier: "firstSegue", sender: self)
    }
    @IBAction func unwind(_ sender: UIStoryboardSegue){}
}
