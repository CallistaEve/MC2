//import UIKit
//import QuartzCore
//import SceneKit
//import GameController
//
//class GameViewController: UIViewController, SCNSceneRendererDelegate {
//    var virtualController: GCVirtualController?
//    
//    var sceneView:SCNView!
//    var scene:SCNScene!
//    var chicken: SCNNode!
//    var camera: SCNNode!
//    
//    var sounds:[String:SCNAudioSource] = [:]
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupScene()
//        setupController()
//        setupNodes()
//        setupSounds()
//        
//            }
//    func setupScene(){
//        sceneView = self.view as! SCNView
//        sceneView.allowsCameraControl = true
//        scene = SCNScene(named: "art.scnassets/Stage/Rumah Ayam.scn")
//        sceneView.scene = scene
//        
//        //         Create and add a camera to the scene
//                let camera = SCNCameraController()
//                
//                // Create and add a light to the scene
//                let lightNode = SCNNode()
//                lightNode.light = SCNLight()
//                lightNode.light!.type = .omni
//                lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
//                scene.rootNode.addChildNode(lightNode)
//
//                // Create and add an ambient light to the scene
//                let ambientLightNode = SCNNode()
//                ambientLightNode.light = SCNLight()
//                ambientLightNode.light!.type = .ambient
//                ambientLightNode.light!.color = UIColor.darkGray
//                scene.rootNode.addChildNode(ambientLightNode)
//
//        //        // Set the view's delegate
//        //        scnView.delegate = self
//
//                // Disables the user from manipulating the camera
//        //        scnView.allowsCameraControl = true
//
//                // Show statistics such as fps and timing information
////                scnView.showsStatistics = true
//    }
//    
//    func setupNodes(){
//        chicken = scene.rootNode.childNode(withName: "chicken", recursively: true)!
//        camera = scene.rootNode.childNode(withName: "camera", recursively: true)!
//        let moveAction = SCNAction.move(by: SCNVector3(0, 0, 0), duration: 0)
//        
//        chicken.runAction(moveAction)
//        camera.runAction(moveAction)
//    }
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
//
//    func virtualControllerInput(gamepad: GCExtendedGamepad, element: GCControllerElement) {
//        if element == gamepad.leftThumbstick {
//            let xValue = gamepad.leftThumbstick.xAxis.value
//            let yValue = gamepad.leftThumbstick.yAxis.value
//
//            // Update ship position based on thumbstick values (adjust values as needed)
//            moveChicken(direction: SCNVector3(x: -Float(xValue), y: 0, z: Float(yValue) ))
//            moveCamera(direction: SCNVector3(x: Float(xValue), y: 0, z: -Float(yValue) ))
//        }
//        if element == gamepad.buttonA {
//            jumpChicken(direction: SCNVector3(x: 0, y: 0, z: 5 ))
//        }
//    }
//    
//    func setupSounds(){
//        let backgroundMusic = SCNAudioSource(fileNamed: "ES_Always Too Much - Spectacles Wallet and Watch.mp3")!
//        let slapSound = SCNAudioSource(fileNamed: "Slap1.mp3")!
//        let walkSound = SCNAudioSource(fileNamed: "walk.wav")!
//        
//        slapSound.load()
//        walkSound.load()
//        
//        backgroundMusic.volume = 0.1
//        slapSound.volume = 0.4
//        walkSound.volume = 0.3
//        
//        sounds["slap"] = slapSound
//        sounds["walk"] = walkSound
//        
//        backgroundMusic.loops = true
//        backgroundMusic.load()
//        
//        let musicPlayer = SCNAudioPlayer(source: backgroundMusic)
//        chicken.addAudioPlayer(musicPlayer)
//    }
//    
//    func jumpChicken(direction: SCNVector3){
//        let moveAction = SCNAction.move(by: direction, duration: TimeInterval(3) )
//        chicken.runAction(moveAction)
//        camera.runAction(moveAction)
//    }
//    
//    func moveCamera(direction:SCNVector3){
//        let moveAction = SCNAction.move(by: direction, duration: TimeInterval(0.3) )
//        camera.runAction(moveAction)
//    }
//
//    func moveChicken(direction: SCNVector3) {
////         This function will update the ship's position continuously based on input
//        let moveAction = SCNAction.move(by: direction, duration: TimeInterval(0.3) )
//        chicken.runAction(moveAction)
//    }
//
//    // Override this method to perform per-frame game logic
//    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
//        let scene = SCNScene(named: "art.scnassets/Stage/Rumah Ayam.scn")!
//        guard let camera = scene.rootNode.childNode(withName: "camera", recursively: true) else { return }
//        
//        // Camera offset from target
//        let cameraOffset = SCNVector3(x: 0, y: 2, z: -5) // Adjust offset values for desired view
//        
//        // Calculate new camera position based on target and offset
//        let newCameraPosition = chicken.position
//        
//        // Animate camera movement smoothly
//        SCNTransaction.begin()
//        SCNTransaction.animationDuration = 0.1
//        camera.position = newCameraPosition
//        SCNTransaction.commit()
//    }
//
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
//
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        if UIDevice.current.userInterfaceIdiom == .phone {
//            return .landscape
//        } else {
//            return .all
//        }
//    }
//}
