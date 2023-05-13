//
//  ViewController.swift
//  Detecting Real World Objects
//
//  Created by Sadhun Arun on 16/11/22.
//

import UIKit
import RealityKit
import ARKit
import AVKit
import Combine

class ViewController: UIViewController , ARSessionDelegate{
    
    @IBOutlet var arView: ARView!
    //Entity and model entities
    var box: ModelEntity!
    var legoModel: Entity!
    var legoParent: ModelEntity!
    var parentEntity: ModelEntity!
    //Anchor Entities
    var anchorEntity: AnchorEntity!
    var legoAnchorEntity: AnchorEntity!
    var videoAnchorEntity: AnchorEntity!
    var textAnchorEntity: AnchorEntity!
    // Animation
    var animation: AnimationResource!
    var animationController: AnimationPlaybackController!
    //Array of type UIButton
    var button: UIButton!
    var buttons = [UIButton?](repeating: UIButton(), count: 5)
    //Video Player
    var videoPlayer: AVPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startTracking()
        legoModel = try! Entity.load(named: "mayaLego")
        arView.session.delegate = self
        createGesture()
    }
    //Start tracking objects
    func startTracking(){
        //Wordl tracking configuration
        let configuration = ARWorldTrackingConfiguration()
        //load reference object (.arobject)
        guard let obj = ARReferenceObject.referenceObjects(inGroupNamed: "bottle", bundle: Bundle.main)
        else{
            print("no object found !")
            return
        }
        configuration.detectionObjects = obj
        //run configuration
        arView.session.run(configuration)
    }
    //Add and update anchors
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        //traverse the anchors
        for anchor in anchors{
            //check if the anchor is of type ARObjectAnchor
            print("anchor found :)")
            guard let objAnchor = anchor as? ARObjectAnchor
            else{
                print("no anchor found ")
                return
            }
            //create 3D anchor node on the object's center
            switch objAnchor.referenceObject.name{
            case "flask":
                print("flask is been updated")
                createAnchorEntity(objAnchor: objAnchor, color: .red, sname: "Flask")
                
                break
            case "lego":
                print("lego is been updated ")
                createAnchorEntity(objAnchor: objAnchor, color: .red, sname: "Lego")
                break
            case "helmet":
                print("helmet has been updated")
                createAnchorEntity(objAnchor: objAnchor, color: .red, sname: "Helmet")
            default:
                print("no obj is updated")
                break
            }
            //Enable gesture recoganization for the user
            //create seperate anchor entities for each object with help of object anchor
            anchorEntity = AnchorEntity(anchor: objAnchor)
            legoAnchorEntity = AnchorEntity(anchor: objAnchor)
            videoAnchorEntity = AnchorEntity(anchor: objAnchor)
            textAnchorEntity = AnchorEntity(anchor: objAnchor)
        }
    }
    //load model
    //create gesture for the user
    func createGesture(){
        //Enable UITapGestureRecoganizer and set the number of taps
        let gesture = UITapGestureRecognizer()
        gesture.numberOfTapsRequired = 1
        //add a target to perform when the user taps on the screen
        gesture.addTarget(self, action: #selector(onTap(recoganizer: )))
        //set user interactions to true so that we can interact with the app
        arView.isUserInteractionEnabled = true
        //add the gesture to the arView
        arView.addGestureRecognizer(gesture)
    }
    //creating Anchor Entity
    func createAnchorEntity(objAnchor: ARObjectAnchor, color: UIColor, sname: String){
        //create Anchor Entity
        anchorEntity = AnchorEntity(anchor: objAnchor)
        //add model entity as a child
        //func sphere() -> generates sphere of type model entity and returns it
        anchorEntity.addChild(sphere(color:color, sname: sname))
        //add anchor to arView
        arView.scene.addAnchor(anchorEntity)
    }
    //create sphere
    func sphere(color: UIColor, sname: String) -> ModelEntity{
        //create model entity
        let sphere = ModelEntity(mesh: .generateSphere(radius: 0.02), materials: [SimpleMaterial(color: color, isMetallic: false)])
        //IMPORTANT - enable collision shapes so that user can interact with the 3D model displayed on the arView
        sphere.generateCollisionShapes(recursive: true)
        //sphere name
        sphere.name = sname
        return sphere
    }
    //create button
    func createButtonArray(text: String, fname: String, color: UIColor, x: Int, y: Int, i: Int){
        //call UIButton and set the titile , materials and color for the button
        button = UIButton()
        button.backgroundColor = color
        button.setTitle(text, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 5
        button.frame = CGRect(x: x, y: y, width: 100, height: 50)
        //storing the button in and array at ith position
        buttons[i]! = button
        //performs button actions based on the function name ie fname
        switch (fname){
        case "playAnimation":
            buttons[i]!.addTarget(self, action: #selector(playAnim), for: .touchUpInside)
            break
        case "stopAnimation":
            buttons[i]!.addTarget(self, action: #selector(stopAnim), for: .touchUpInside)
            break
        case "restartAnimation":
            buttons[i]!.addTarget(self, action: #selector(reAnim), for: .touchUpInside)
            break
        case "resumeAnimation":
            buttons[i]!.addTarget(self, action: #selector(resAnim), for: .touchUpInside)
            break
        case "exitAnimation":
            buttons[i]!.addTarget(self, action: #selector(exitAnim), for: .touchUpInside)
            break
        case "playVideo":
            buttons[i]!.addTarget(self, action: #selector(playVideo), for: .touchUpInside)
            break
        case "pauseVideo":
            buttons[i]!.addTarget(self, action: #selector(pauseVideo), for: .touchUpInside)
            break
        case "exitVideo":
            buttons[i]!.addTarget(self, action: #selector(exitVideo), for: .touchUpInside)
            break
        case "remText":
            buttons[i]!.addTarget(self, action: #selector(removeText), for: .touchUpInside)
            break
        default:
            print("Enter proper name ")
            break
        }
        for b in buttons{
            arView.addSubview(b!)
        }
    }
    //create animation controller
    func createAnimationController(sp: Bool){
        //choose the required animation you want to play
        animation = legoModel.availableAnimations.first
        //create animationController to control your animations
        animationController = legoModel.playAnimation(animation, transitionDuration: 0, startsPaused: sp)
    }
    //create video player
    func createVideoPlayer(){
        //load the downloaded video in respective format
        guard let path = Bundle.main.path(forResource: "flask", ofType: "mp4")
        else{
            print("no video file found ")
            return
        }
        //convert the video into URL
        let videoURL = URL(filePath: path)
        //create video player item
        let playerItem = AVPlayerItem(url: videoURL)
        //create video player to control the play back
        videoPlayer = AVPlayer(playerItem: playerItem)
    }
    //play animation
    @objc
    func playAnim(){
        createAnimationController(sp: false)
    }
    //stop animation
    @objc
    func stopAnim(){
        //check if animation is playing and then pause
        if animationController.isPlaying{
            animationController.pause()
        }
    }
    //resume animation
    @objc
    func resAnim(){
        //check if animation is paused and then resume
        if animationController.isPaused{
            animationController.resume()
        }
    }
    //restart animation
    @objc
    func reAnim(){
        createAnimationController(sp: true)
    }
    //exit the play mode
    @objc
    func exitAnim(){
        print(buttons.count)
        //iterate throuhg the buttons and remove them from the SuperView (ie) arView
        for b in buttons{
            b?.removeFromSuperview()
        }
        //remove the lego anchor entity or else the model will be still anchored to the scene
        arView.scene.removeAnchor(legoAnchorEntity)
        //legoModel = nil
    }
    //play video
    @objc
    func playVideo(){
        videoPlayer.play()
    }
    //pause video
    @objc
    func pauseVideo(){
        videoPlayer.pause()
    }
    //exit video player
    @objc
    func exitVideo(){
        //iterate throught the buttons and remove from the view
        for b in buttons{
            b?.removeFromSuperview()
        }
        arView.scene.removeAnchor(videoAnchorEntity)
        //pause the player or else it will be playing in the background
        videoPlayer = nil
    }
    @objc
    //remove text in screen
    func removeText(){
        for b in buttons{
            b?.removeFromSuperview()
        }
        arView.scene.removeAnchor(textAnchorEntity)
    }
    //func for tap gesture
    @objc
    func onTap(recoganizer: UITapGestureRecognizer){
        let tapLocation = recoganizer.location(in: arView)
        guard let entity = arView.entity(at: tapLocation)
        else{
            print("no entity found !")
            return
        }
        print(entity.name)
        if entity.name == "Lego"{
            createButtonArray(text: "Play", fname: "playAnimation", color: .green, x: 5, y: 50, i: 0)
            createButtonArray(text: "Stop", fname: "stopAnimation", color: .red, x: 105, y: 50, i: 1)
            createButtonArray(text: "Resume", fname: "resumeAnimation", color: .yellow, x: 205, y: 50, i: 2)
            createButtonArray(text: "Restart", fname: "restartAnimation", color: .gray, x: 305, y: 50, i: 3)
            createButtonArray(text: "Exit", fname: "exitAnimation", color: .white, x: 65, y: 100, i: 4)
            legoAnchorEntity.addChild(legoModel)
            arView.scene.addAnchor(legoAnchorEntity)
        }
        else if entity.name == "Flask"{
            createVideoPlayer()
            let videoMaterial = VideoMaterial(avPlayer: videoPlayer)
            let videoPlane = ModelEntity(mesh: .generatePlane(width: 0.4, height: 0.3, cornerRadius: 0.02), materials: [videoMaterial])
            videoPlane.generateCollisionShapes(recursive: true)
            videoPlane.setPosition([entity.position.x - 0.6, entity.position.y + 0.4, entity.position.z], relativeTo: entity)
            arView.installGestures([.translation], for: videoPlane)
            createButtonArray(text: "Play", fname: "playVideo", color: .green, x: 5, y: 50, i: 0)
            createButtonArray(text: "Pause", fname: "pauseVideo", color: .yellow, x: 105, y: 50, i: 1)
            createButtonArray(text: "Exit", fname: "exitVideo", color: .white, x: 205, y: 50, i: 2)
            videoAnchorEntity.addChild(videoPlane)
            arView.scene.addAnchor(videoAnchorEntity)
            
        }
        else if entity.name == "Helmet"{
            let textShape = MeshResource.generateText("This is a Helmet")
            var textMaterial = SimpleMaterial()
            textMaterial.color.tint = .red
            let myText = ModelEntity(mesh: textShape, materials: [textMaterial])
            createButtonArray(text: "Remove", fname: "remText", color: .gray, x: 5, y: 50, i: 0)
            myText.scale = [0.01, 0.01, 0.01]
            myText.setPosition([entity.position.x - 1.2, entity.position.y + 0.3, entity.position.z], relativeTo: entity)
            textAnchorEntity.addChild(myText)
            arView.scene.addAnchor(textAnchorEntity)
        }
        else{
            print("no entity with that name ")
        }
    }
}
