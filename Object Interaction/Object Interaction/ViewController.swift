//
//  ViewController.swift
//  Object Interaction
//
//  Created by Sadhun Arun on 03/11/22.
//

import UIKit
import RealityKit
import ARKit



class ViewController: UIViewController, ARSessionDelegate{
    
    @IBOutlet var arView: ARView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let box1 = ModelEntity(mesh: .generateBox(size: 0.2), materials: [SimpleMaterial(color: .blue, isMetallic: true)])
        let box2 = ModelEntity(mesh: .generateBox(size: 0.2), materials: [SimpleMaterial(color: .cyan, isMetallic: true)])
        box2.setPosition([0.5, 0, 0], relativeTo: box1)
        box1.name = "bb1"
        box2.name = "bb2"
        box1.generateCollisionShapes(recursive: true)
        box2.generateCollisionShapes(recursive: true)
        //gesture create
        createGesture(box1: box1, box2: box2)
        revertGesture(box1: box1, box2: box2)
        box1.generateCollisionShapes(recursive: true)
        box2.generateCollisionShapes(recursive: true)
        let planeAnchor = AnchorEntity(plane: .horizontal)
        planeAnchor.addChild(box1)
        planeAnchor.addChild(box2)
        arView.scene.addAnchor(planeAnchor)
    }
    func createGesture(box1: ModelEntity, box2: ModelEntity){
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tg))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        arView.addGestureRecognizer(gesture)
        arView.installGestures(for: box1)
        arView.installGestures(for: box2)
    }
    func revertGesture(box1: ModelEntity, box2: ModelEntity){
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(rg))
        gesture.minimumPressDuration = 1
        gesture.numberOfTouchesRequired = 1
        arView.addGestureRecognizer(gesture)
        arView.installGestures(for: box1)
        arView.installGestures(for: box2)
    }
    @IBAction
    func tg(sender: UITapGestureRecognizer){
        let tapLocation = sender.location(in: arView)
        if let entity = arView.entity(at: tapLocation){
            if entity.name == "bb1"{
                entity.setPosition([-0.5, 0, 0], relativeTo: entity)
                print(entity.name)
            }
            else {
                entity.setPosition([0.5, 0, 0], relativeTo: entity)
                print(entity.name)
            }
        }
        else {
            print("no model found !")
        }
    }
    @IBAction
    func rg(sender: UITapGestureRecognizer){
        let tapLocation = sender.location(in: arView)
        if let entity = arView.entity(at: tapLocation){
            if entity.name == "bb1"{
                entity.setPosition([0.3, 0, 0], relativeTo: entity)
            }
            else {
                entity.setPosition([-0.3, 0, 0], relativeTo: entity)
            }
        }
    }
//    @IBAction
//    func tg2(sender: UITapGestureRecognizer){
//        let tapLocation = sender.location(in: arView)
//        if let entity = arView.entity(at: tapLocation){
//            entity.setPosition([0.3, 0, 0], relativeTo: entity)
//            print(entity.name)
//        }
//        else {
//            print("no model found !")
//        }
//    }
//    override func viewDidAppear(_ animated: Bool) {
//        g1 = createGesture1()
//        g2 = createGesture1()
//    }
//    //tap gesture
//    func createGesture2() -> UITapGestureRecognizer{
//        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture2))
//        gesture.numberOfTapsRequired = 1
//        gesture.numberOfTouchesRequired = 1
//        arView.addGestureRecognizer(gesture)
//        arView.isUserInteractionEnabled = true
//        print("in gesture 2")
//        return gesture
//    }
//    func createGesture1() -> UITapGestureRecognizer{
//        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture1))
//        gesture.numberOfTapsRequired = 1
//        gesture.numberOfTouchesRequired = 1
//        arView.addGestureRecognizer(gesture)
//        arView.isUserInteractionEnabled = true
//        print("in gesture 1")
//        return gesture
//    }
//
//    //action for tap gesture
//    @IBAction
//    func tapGesture1(_ sender: UITapGestureRecognizer){
//        let tapLocation = sender.location(in: arView)
//        if let hitEntity = arView.entity(at: tapLocation){
//            if hitEntity.name == "bb1"{
//                parentEntity.findEntity(named: "bb1")?.move(t, relativeTo: <#T##Entity?#>)
//                parentEntity.findEntity(named: "bb1").model?.materials = [SimpleMaterial(color: .blue, isMetallic: true)]
//                print(hitEntity.name)
//                hitEntity.setPosition([-0.3, 0, 0], relativeTo: hitEntity)
//            }
//        }
//        else {
//            print("no entity found !")
//        }
//    }
//    @IBAction
//    func tapGesture2(_ sender: UITapGestureRecognizer){
//        let tapLocation = sender.location(in: arView)
//        if let hitEntity = arView.entity(at: tapLocation){
//            if hitEntity.name == "bb2"{
//                box2.model?.materials = [SimpleMaterial(color: .blue, isMetallic: true)]
//                print(hitEntity.name)
//                hitEntity.setPosition([0.3, 0, 0], relativeTo: hitEntity)
//            }
//        }
//        else {
//            print("no entity found !")
//        }
//    }
//    //action for hold gesture

}
