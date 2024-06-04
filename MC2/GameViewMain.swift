import UIKit
import QuartzCore
import SceneKit
import GameController

class GameViewController:UIViewController, SCNPhysicsContactDelegate{
    var virtualController: GCVirtualController?
    
    enum bitmask: Int{
        case player = 1
        case object = 2
        case villager = 4
    }
    
    var cameraNode = SCNNode()
    
    var chicken = SCNNode()
    var camera = SCNNode()
    var object = SCNNode()
    var floor = SCNNode()
    
    override func viewDidLoad()
        {
            super.viewDidLoad()
            setupController()
            
            let scene = SCNScene(named: "art.scnassets/Stage/Scene.scn")!
            
            scene.physicsWorld.contactDelegate = self
            
//            cameraNode.camera = SCNCamera()
//            cameraNode.camera?.zFar = 500
            
            let dummyNode = SCNNode()
            scene.rootNode.addChildNode(dummyNode)
            
            chicken = scene.rootNode.childNode(withName: "Chicken reference", recursively: true)!
            object = scene.rootNode.childNode(withName: "object", recursively: true)!
//            floor = scene.rootNode.childNode(withName: "floor", recursively: true)!
            if let dummyNode = scene.rootNode.childNode(withName: "dummyNode", recursively: false) {
              dummyNode.position = SCNVector3(0, -5, -5)
              // ... rest of your code using dummyNode
            } else {
                // Handle the case where DummyNode is not found (optional)
                print("Warning: DummyNode not found in scene")
            }

            scene.rootNode.enumerateChildNodes { (node, _) in
               if (node.name == "Chicken reference") {
                 chicken = node
                 chicken.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: chicken, options: nil ))
                 // ... (rest of chicken physics body setup)
                   chicken.physicsBody?.categoryBitMask = bitmask.player.rawValue  //
                 chicken.physicsBody?.collisionBitMask = bitmask.object.rawValue // Combine categories (floor & object)
               } else if (node.name == "object") {
                 object = node
                 object.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(node: object, options: nil ))
                 // ... (rest of cone physics body setup)
                   object.physicsBody?.categoryBitMask = bitmask.object.rawValue  // Set cone's category to object
               }
             }

            
            // retrieve the SCNView
            let scnView = self.view as! SCNView
            
            let cameraNode = SCNCameraController()
            camera = (scene.rootNode.childNode(withName: "camera", recursively: true))!
            
            // set the scene to the view
            scnView.scene = scene
            
            // allows the user to manipulate the camera
//            scnView.allowsCameraControl = true
            
            // show statistics such as fps and timing information
            scnView.showsStatistics = true
            
            
            
        }
    
//    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
//        let nodeA = contact.nodeA
//        let nodeB = contact.nodeB
//
//        if (nodeA == chicken && nodeB == cone) || (nodeA == cone && nodeB == chicken) {
//            // Chicken collided with cone
//            // Get the movement direction from the gamepad input
//            let gamepad = virtualController?.controller?.extendedGamepad
//            let xValue = gamepad?.leftThumbstick.xAxis.value ?? 0
//            let yValue = gamepad?.leftThumbstick.yAxis.value ?? 0
//            var movementDirection = SCNVector3(x: -Float(xValue), y: 0, z: Float(yValue))
//
//            // Check the collision direction and prevent movement in that direction
//            let contactNormal = contact.contactNormal
//            if contactNormal.x > 0 {
//                movementDirection.x = 0
//            } else if contactNormal.x < 0 {
//                movementDirection.x = 0
//            }
//            if contactNormal.z > 0 {
//                movementDirection.z = 0
//            } else if contactNormal.z < 0 {
//                movementDirection.z = 0
//            }
//
//            // Update chicken movement based on the modified direction
//            moveChicken(direction: movementDirection)
//        }
//    }

    
    
    func setupController() {
        let controllerConfig = GCVirtualController.Configuration()
        controllerConfig.elements = [GCInputLeftThumbstick, GCInputButtonA, GCInputButtonB]

        virtualController = GCVirtualController(configuration: controllerConfig)
        virtualController?.connect()

        virtualController?.controller?.extendedGamepad?.valueChangedHandler = { [weak self] gamepad, element in
            self?.virtualControllerInput(gamepad: gamepad, element: element)
        }
    }
    func moveChicken(direction: SCNVector3) {
        let moveAction = SCNAction.move(by: direction, duration: TimeInterval(5) )
//        chicken.runAction(SCNAction.playAudio(walkSound, waitForCompletion: true))
        chicken.runAction(moveAction)
    }
    func virtualControllerInput(gamepad: GCExtendedGamepad, element: GCControllerElement) {
        if element == gamepad.leftThumbstick {
            let xValue = gamepad.leftThumbstick.xAxis.value
            let yValue = gamepad.leftThumbstick.yAxis.value

            // Update ship position based on thumbstick values (adjust values as needed)
            moveChicken(direction: SCNVector3(x: -Float(xValue), y: 0, z: Float(yValue) ))
//            moveCamera(direction: SCNVector3(x: Float(xValue), y: 0, z: -Float(yValue) ))
        }
//        if element == gamepad.buttonA {
//            jumpChicken(direction: SCNVector3(x: 0, y: chickenPlayerData.jumpCount, z: 0))
//            
//            
//        }
//        if element == gamepad.buttonB {
//            chicken.runAction(SCNAction.playAudio(slapSound, waitForCompletion: true))
//        }
    }
        override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
            if UIDevice.current.userInterfaceIdiom == .phone {
                return .landscape
            } else {
                return .all
            }
        }
}



