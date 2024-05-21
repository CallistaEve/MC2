//
//  GameViewController.swift
//  MC2
//
//  Created by Evelyn Callista Yaurentius on 18/05/24.
//

import UIKit
import QuartzCore
import SceneKit
import GameController


class GameViewController: UIViewController {
    var virtualController:GCVirtualController?
    
    override func viewDidLoad() {
        super.viewDidLoad()


        setupController()

        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!

        // Create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)

        // Place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)

        // Create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)

        // Create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)

        // Retrieve the ship node
//        ship = scene.rootNode.childNode(withName: "ship", recursively: true)

        // Retrieve the SCNView
        let scnView = self.view as! SCNView

        // Set the scene to the view
        scnView.scene = scene

//        // Set the view's delegate
//        scnView.delegate = self

        // Allows the user to manipulate the camera
        scnView.allowsCameraControl = true

        // Show statistics such as fps and timing information
        scnView.showsStatistics = true

        // Configure the view
        scnView.backgroundColor = UIColor.black

        // Add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
    }

    @objc
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        // Retrieve the SCNView
        let scnView = self.view as! SCNView

        // Check what nodes are tapped
        let p = gestureRecognize.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        // Check that we clicked on at least one object
        if hitResults.count > 0 {
            // Retrieved the first clicked object
            let result = hitResults[0]

            // Get its material
            let material = result.node.geometry!.firstMaterial!

            // Highlight it
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5

            // On completion - unhighlight
            SCNTransaction.completionBlock = {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.5

                material.emission.contents = UIColor.black

                SCNTransaction.commit()
            }

            material.emission.contents = UIColor.red

            SCNTransaction.commit()
        }
    }

    func setupController() {
        let controllerConfig = GCVirtualController.Configuration()
        controllerConfig.elements = [
            GCInputLeftThumbstick
        ]

        let controller = GCVirtualController(configuration: controllerConfig)
        controller.connect()
        virtualController = controller
    }

    // Override this method to perform per-frame game logic
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard let virtualController = virtualController else { return }

        // Get left thumbstick values
        if let thumbstick = virtualController.controller?.extendedGamepad?.leftThumbstick {
            let xValue = thumbstick.xAxis.value
            let yValue = thumbstick.yAxis.value

            // Update ship position based on thumbstick values (adjust values as needed)
//            ship.position.x += Float(xValue) * 0.1
//            ship.position.z += Float(yValue) * 0.1
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .landscape
        } else {
            return .all
        }
    }
}
