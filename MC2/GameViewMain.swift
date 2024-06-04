//import UIKit
//import QuartzCore
//import SceneKit
//import GameController
//
//class GameViewController:UIViewController, SCNPhysicsContactDelegate{
//    var scene = SCNScene()
//    var virtualController: GCVirtualController?
//    
//    var cameraNode = SCNNode()
//    
//    var chicken = SCNNode()
//    var camera = SCNNode()
//    var cone = SCNNode()
//    
//    override func viewDidLoad()
//        {
//            super.viewDidLoad()
//            setupController()
//            
//            scene = SCNScene(named: "art.scnassets/Stage/Scene.scn")!
//            
//            scene.physicsWorld.contactDelegate = self
//            
//            cameraNode.camera = SCNCamera()
//            cameraNode.camera?.zFar = 500
//            
//            let floor = SCNFloor()
//            let floorMaterial = SCNMaterial()
//            floor.firstMaterial = floorMaterial
//            let floorNode = SCNNode(geometry: floor)
//            scene.rootNode.addChildNode(floorNode)
//            
//            cone = (scene.rootNode.childNode(withName: "cone", recursively: true))!
//            cone.physicsBody = SCNPhysicsBody.static()
//            cone.physicsBody!.contactTestBitMask = 1
//            
//            chicken = (scene.rootNode.childNode(withName: "Chicken reference", recursively: true))!
//            chicken.physicsBody = SCNPhysicsBody.kinematic()
//            chicken.physicsBody!.contactTestBitMask = 1
//            
//            // retrieve the SCNView
//            let scnView = self.view as! SCNView
//            
//            let cameraNode = SCNCameraController()
//            camera = (scene.rootNode.childNode(withName: "camera", recursively: true))!
//            
//            // set the scene to the view
//            scnView.scene = scene
//            
//            // allows the user to manipulate the camera
//            scnView.allowsCameraControl = true
//            
//            // show statistics such as fps and timing information
//            scnView.showsStatistics = true
//            
//            
//        }
//    
////    Mark: Contact
//    
//    
//    func setupController() {
//        let controllerConfig = GCVirtualController.Configuration()
//        controllerConfig.elements = [GCInputLeftThumbstick, GCInputButtonA, GCInputButtonB]
//
//        virtualController = GCVirtualController(configuration: controllerConfig)
//        virtualController?.connect()
//
//        virtualController?.controller?.extendedGamepad?.valueChangedHandler = { [weak self] gamepad, element in
//            self?.virtualControllerInput(gamepad: gamepad, element: element)
//        }
//    }
//    func moveChicken(direction: SCNVector3) {
//        let moveAction = SCNAction.move(by: direction, duration: TimeInterval(5) )
////        chicken.runAction(SCNAction.playAudio(walkSound, waitForCompletion: true))
//        chicken.runAction(moveAction)
//    }
//    func virtualControllerInput(gamepad: GCExtendedGamepad, element: GCControllerElement) {
//        if element == gamepad.leftThumbstick {
//            let xValue = gamepad.leftThumbstick.xAxis.value
//            let yValue = gamepad.leftThumbstick.yAxis.value
//
//            // Update ship position based on thumbstick values (adjust values as needed)
//            moveChicken(direction: SCNVector3(x: -Float(xValue), y: 0, z: Float(yValue) ))
////            moveCamera(direction: SCNVector3(x: Float(xValue), y: 0, z: -Float(yValue) ))
//        }
////        if element == gamepad.buttonA {
////            jumpChicken(direction: SCNVector3(x: 0, y: chickenPlayerData.jumpCount, z: 0))
////            
////            
////        }
////        if element == gamepad.buttonB {
////            chicken.runAction(SCNAction.playAudio(slapSound, waitForCompletion: true))
////        }
//    }
//        override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//            if UIDevice.current.userInterfaceIdiom == .phone {
//                return .landscape
//            } else {
//                return .all
//            }
//        }
//}
//
//
//
