//
//  GameViewController.swift
//  fortunewheel
//
//  Created by Andrey Bronin on 06/01/2019.
//  Copyright © 2019 Insolar. All rights reserved.
//

import SceneKit
import QuartzCore

class GameViewController: NSViewController {
    
    var wheel = SCNNode()
    var rotateAction = SCNAction()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // create and add a camera to the scene
        /*
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 25)
        */
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = NSColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        
        // retrieve the ship node
        wheel = scene.rootNode.childNode(withName: "wheelPart", recursively: true)!
        
        // flip wheel texture
        wheel.geometry?.material(named: "wheel")?.diffuse.contentsTransform = SCNMatrix4FromGLKMatrix4(GLKMatrix4(m: (
            -1.0, 0.0, 0.0, 0.0,
            0.0, 1.0, 0.0, 0.0,
            0.0, 0.0, 1.0, 0.0,
            -1.0, 0.0, 0.0, 1.0
        )))

        rotateAction = SCNAction.rotateBy(x: 0, y: 0, z: -5, duration: Double.random(in: 1...16))
        //wheel.runAction(SCNAction.repeatForever(rotateAction))
        //wheel.runAction(rotateAction)

        
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = NSColor.black
        
        // Add a click gesture recognizer
        let clickGesture = NSClickGestureRecognizer(target: self, action: #selector(handleClick(_:)))
        var gestureRecognizers = scnView.gestureRecognizers
        gestureRecognizers.insert(clickGesture, at: 0)
        scnView.gestureRecognizers = gestureRecognizers
    }
    
    @objc
    func handleClick(_ gestureRecognizer: NSGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // check what nodes are clicked
        let p = gestureRecognizer.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result = hitResults[0]
            
            if result.node.name == "wheelPart" {
                rotateAction.duration = Double.random(in: 1...8)
                //rotateAction.speed = CGFloat.random(in: 4...16)
                wheel.removeAllActions()
               // wheel.eulerAngles.z = 0
                wheel.runAction( rotateAction, forKey: "spin", completionHandler: spinHandler)

            }
            if result.node.name == "arrow" {
                spinHandler()
            }
        }
    }
    
    func spinHandler() {
        wheel.removeAllActions()
        print("The Section is: ", getSectionName())
        // TODO: show result text on the scene
    }
    
    func getSectionName() -> String {
        var halfSections: [String] = ["BORROW", "PROFIT", "LOSS", "GAIN", "PROFIT", "EXPAND", "WIN", "CAPITAL"]
        halfSections += halfSections
        
        let zAngle = wheel.eulerAngles.z
        let zDegree = Int(zAngle * 180 / .pi)
        
        // 22.5 degrees is one sector of the wheel
        let sectionDegree: Double = -22.5
        let section = Double(zDegree % 360) / sectionDegree
        debugPrint(section)
        
        return halfSections[Int(section)]
    }
    
}
