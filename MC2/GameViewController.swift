import UIKit
import QuartzCore
import SceneKit
import GameController

class GameViewController: UIViewController, SCNSceneRendererDelegate {
    var virtualController: GCVirtualController?
    var chicken: SCNNode!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupController()

        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/rumah ayam copy.scn")!
    
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
        chicken = scene.rootNode.childNode(withName: "chicken", recursively: true)
        let moveAction = SCNAction.move(by: SCNVector3(0, 0, 0), duration: 0)
        chicken.runAction(moveAction)
        
        if let retrievedShip = scene.rootNode.childNode(withName: "chicken", recursively: true) {
            chicken = retrievedShip
        } else {
          // Handle the case where the node is not found (print an error message, etc.)
          print("Error: Could not find node named 'chicken' in the scene.")
        }


        // Retrieve the SCNView
        let scnView = self.view as! SCNView

        // Set the scene to the view
        scnView.scene = scene

//        // Set the view's delegate
//        scnView.delegate = self

        // Disables the user from manipulating the camera
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
        controllerConfig.elements = [GCInputLeftThumbstick, GCInputButtonA, GCInputButtonB]

        virtualController = GCVirtualController(configuration: controllerConfig)
        virtualController?.connect()

        virtualController?.controller?.extendedGamepad?.valueChangedHandler = { [weak self] gamepad, element in
            self?.virtualControllerInput(gamepad: gamepad, element: element)
        }
    }

    func virtualControllerInput(gamepad: GCExtendedGamepad, element: GCControllerElement) {
        if element == gamepad.leftThumbstick {
            let xValue = gamepad.leftThumbstick.xAxis.value
            let yValue = gamepad.leftThumbstick.yAxis.value

            // Update ship position based on thumbstick values (adjust values as needed)
            moveChicken(direction: SCNVector3(x: -Float(xValue), y: -Float(yValue), z: 0 ))
        }
        if element == gamepad.buttonA {
            jumpChicken(direction: SCNVector3(x: 0, y: 0, z: 5 ))
        }
    }
    
    func jumpChicken(direction: SCNVector3){
        let moveAction = SCNAction.move(by: direction, duration: TimeInterval(0.3) )
        chicken.runAction(moveAction)
//        chicken.runAction(SCNAction.move(by: SCNVector3(x: 0, y: 0, z: 0), duration: 0.3))
    }

    func moveChicken(direction: SCNVector3) {
//         This function will update the ship's position continuously based on input
        let moveAction = SCNAction.move(by: direction, duration: TimeInterval(0.3) )
        chicken.runAction(moveAction)
        
//        ship.position.x += direction.x
//        ship.position.z += direction.z
    }

    // Override this method to perform per-frame game logic
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        let scene = SCNScene(named: "art.scnassets/rumah ayam copy.scn")!
      guard let virtualController = virtualController, let chicken = chicken else { return }

      // Update ship position based on thumbstick values (adjust values as needed)
      if let thumbstick = virtualController.controller?.extendedGamepad?.leftThumbstick {
        let xValue = thumbstick.xAxis.value
        let yValue = thumbstick.yAxis.value
          chicken.position.x += Float(xValue) * 0.1
          chicken.position.y += Float(yValue) * 0.1
      }
      // Update camera position to follow the ship with an offset
      let cameraOffset = SCNVector3(x: 0, y: 5, z: 0) // Adjust offset values for desired view
      let newCameraPosition = SCNVector3(x: chicken.position.x, y: chicken.position.y , z: 0)
      
      // Animate camera movement smoothly
      SCNTransaction.begin()
      SCNTransaction.animationDuration = 0.1
      scene.rootNode.childNode(withName: "camera", recursively: true)?.position = newCameraPosition
      SCNTransaction.commit()
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
