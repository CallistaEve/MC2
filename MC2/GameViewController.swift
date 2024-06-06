import UIKit
import QuartzCore
import SceneKit
import GameController

class GameViewController: UIViewController, SCNSceneRendererDelegate, SCNPhysicsContactDelegate {
    enum bitmask: Int{
        case player = 1
        case object = 2
        case villager = 4
    }
    
    var virtualController: GCVirtualController?
    
    var chicken: SCNNode!
    var object: SCNNode!
    var root: SCNNode!
    var camera: SCNNode!
    
    var sounds:[String:SCNAudioSource] = [:]
    var chickenPlayerData = ChickenPlayerData().playerChicken
    var backgroundMusic: SCNAudioSource!
    var slapSound: SCNAudioSource!
    var walkSound: SCNAudioSource!
    
    override func viewDidLoad() {
        var isWalk = chickenPlayerData.isWalk = false
        super.viewDidLoad()

        setupController()
        setupNode()
        setupSounds()
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
    
    func setupNode(){
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/Stage/Stage1.scn")!
//        guard let chickenHouse = scene.rootNode.childNode(withName: "Rumah_Ayam_002", recursively: false) else { return }
//        chickenHouse.physicsBody?.type = .static
//        chickenHouse.physicsBody?.
        // Create and add a camera to the scene
        let cameraNode = SCNCameraController()
        
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

        // Retrieve the objects node
        chicken = scene.rootNode.childNode(withName: "NewChicken reference", recursively: true)
        object = scene.rootNode.childNode(withName: "plane", recursively: true)
        root = scene.rootNode.childNode(withName: "root", recursively: true)
        camera = scene.rootNode.childNode(withName: "cameraFocus", recursively: true)
        
        
        let moveAction = SCNAction.move(by: SCNVector3(0, 0, 0), duration: 0)
        
        chicken.runAction(moveAction)
//        chicken.physicsBody = SCNPhysicsBody(type: .kinematic, shape: SCNPhysicsShape(node: chicken, options: nil ))
//        chicken.physicsBody?.isAffectedByGravity = true
//        chicken.physicsBody?.categoryBitMask = 1
//        chicken.physicsBody?.collisionBitMask = 2 | 4
//
//
//        root.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(node: root, options: nil ))
//        root.physicsBody?.categoryBitMask = 2
//        root.physicsBody?.collisionBitMask = 1
//
//        object.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(node: object, options: nil ))
//        object.physicsBody?.categoryBitMask = 4
//        object.physicsBody?.collisionBitMask = 1
        
        camera.runAction(moveAction)
        
        // Retrieve the SCNView
        let scnView = self.view as! SCNView

        // Set the scene to the view
        scnView.scene = scene
        
                // Set the view's delegate
//                scnView.delegate = self
//
//                // Disables the user from manipulating the camera
//                scnView.allowsCameraControl = true

                // Show statistics such as fps and timing information
//                scnView.showsStatistics = true

                // Configure the view
                scnView.backgroundColor = UIColor.black
    }

    func virtualControllerInput(gamepad: GCExtendedGamepad, element: GCControllerElement) {
        if element == gamepad.leftThumbstick {
            let xValue = gamepad.leftThumbstick.xAxis.value
            let yValue = gamepad.leftThumbstick.yAxis.value

            // Update ship position based on thumbstick values (adjust values as needed)
            moveChicken(direction: SCNVector3(x: Float(xValue), y: 0, z: -Float(yValue) ))
            moveCamera(direction: SCNVector3(x: Float(xValue), y: 0, z: -Float(yValue) ))
        }
        if element == gamepad.buttonA {
//            if chicken.physicsBody?.velocity.y == 0 { // Adjust check as needed (e.g., small epsilon value)
                  jumpChicken(direction: SCNVector3(x: 0, y: 10, z: 0))
        }
        if element == gamepad.buttonB {
            chicken.runAction(SCNAction.playAudio(slapSound, waitForCompletion: true))
        }
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
        chicken.addAudioPlayer(musicPlayer)
    }
    
    func jumpChicken(direction: SCNVector3) {
      // Apply an upward force to simulate jump
      chicken.physicsBody?.applyForce(SCNVector3(x: 0, y: 5, z: 0), at: SCNVector3(x: 0, y: 0.5, z: 0), asImpulse: true)
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
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
      let nodeA = contact.nodeA
      let nodeB = contact.nodeB

      if (nodeA == chicken && nodeB == object) || (nodeA == object && nodeB == chicken) {
        print("Kena Plane")
      } else if (nodeA == chicken && nodeB == root) || (nodeA == root && nodeB == chicken) {
        print("Kena Lantai")
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
