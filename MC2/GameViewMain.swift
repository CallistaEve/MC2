import UIKit
import QuartzCore
import SceneKit
import GameController

class GameViewController1:UIViewController, SCNPhysicsContactDelegate, SCNSceneRendererDelegate{
    var virtualController: GCVirtualController?
    
    enum bitmask: Int{
        case player = 1
        case object = 2
        case villager = 4
    }
    
    var chicken: SCNNode!
    var camera: SCNNode!
    var text: SCNNode!
    
    
    var sounds:[String:SCNAudioSource] = [:]
    var chickenPlayerData = ChickenPlayerData().playerChicken
    var backgroundMusic: SCNAudioSource!
    var slapSound: SCNAudioSource!
    var walkSound: SCNAudioSource!
    
    var cameraNode = SCNNode()
    
    var object = SCNNode()
    var floor = SCNNode()
    
    override func viewDidLoad()
        {
            super.viewDidLoad()
            setupController()
            setupSounds()
            
            let scene = SCNScene(named: "art.scnassets/Stage/Scene.scn")!
            
            scene.physicsWorld.contactDelegate = self
            
//            cameraNode.camera = SCNCamera()
//            cameraNode.camera?.zFar = 500
            
            let dummyNode = SCNNode()
            scene.rootNode.addChildNode(dummyNode)
            camera = scene.rootNode.childNode(withName: "camera", recursively: true)
            chicken = scene.rootNode.childNode(withName: "NewChicken reference", recursively: true)!
            object = scene.rootNode.childNode(withName: "cone1", recursively: true)!
            text = scene.rootNode.childNode(withName: "text node", recursively: true)!
            
            text.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: text, options: nil ))
            text.physicsBody?.categoryBitMask = 8
            text.physicsBody?.collisionBitMask = 0

            
            text.isHidden = true
//            floor = scene.rootNode.childNode(withName: "floor", recursively: true)!
            if let dummyNode = scene.rootNode.childNode(withName: "dummyNode", recursively: false) {
              dummyNode.position = SCNVector3(0, -5, -5)
              // ... rest of your code using dummyNode
            } else {
                // Handle the case where DummyNode is not found (optional)
                print("Warning: DummyNode not found in scene")
            }

            scene.rootNode.enumerateChildNodes { (node, _) in
               if (node.name == "NewChicken reference") {
                 chicken = node
                 chicken.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: chicken, options: nil ))
                 // ... (rest of chicken physics body setup)
                   chicken.physicsBody?.categoryBitMask = bitmask.player.rawValue  //
                 chicken.physicsBody?.collisionBitMask = bitmask.object.rawValue // Combine categories (floor & object)
                   print("Ayam")
               }
                else if (node.name == "cone1") {
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
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        let nodeA = contact.nodeA
        let nodeB = contact.nodeB

        if (nodeA == chicken && nodeB == object) || (nodeA == object && nodeB == chicken) {
            text.isHidden = false
            text.geometry?.firstMaterial?.diffuse.contents = "Collided!" // Change to your desired text
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
    func jumpChicken(direction: SCNVector3){
        let moveAction = SCNAction.move(by: direction, duration: TimeInterval(3) )
        chicken.runAction(moveAction)
        camera.runAction(moveAction)
    }
    
    func moveCamera(direction:SCNVector3){
        let moveAction = SCNAction.move(by: direction, duration: TimeInterval(5) )
        camera.runAction(moveAction)
    }

    func moveChicken(direction: SCNVector3) {
        let moveAction = SCNAction.move(by: direction, duration: TimeInterval(5) )
        chicken.runAction(SCNAction.playAudio(walkSound, waitForCompletion: true))
        chicken.runAction(moveAction)
    }
    func setupSounds(){
        backgroundMusic = SCNAudioSource(fileNamed: chickenPlayerData.backgroundSound)!
        slapSound = SCNAudioSource(fileNamed: chickenPlayerData.slapVoice.randomElement()?.rawValue ?? "Slap1.mp3")!
        walkSound = SCNAudioSource(fileNamed: chickenPlayerData.footstepSound)!
        
        slapSound.load()
        walkSound.load()
        
        backgroundMusic.volume = 0.1
        slapSound.volume = 0.4
        walkSound.volume = 0.3
        
        sounds["Slap1"] = slapSound
        sounds["walk"] = walkSound
        
        backgroundMusic.loops = true
        backgroundMusic.load()
        
        let musicPlayer = SCNAudioPlayer(source: backgroundMusic)
//        chicken.addAudioPlayer(musicPlayer)
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



