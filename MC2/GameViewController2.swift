////
////  GameViewController2.swift
////  MC2
////
////  Created by Evelyn Callista Yaurentius on 30/05/24.
////
//
//import UIKit
//import SceneKit
//
//class GameViewController: UIViewController{
//    var sceneView:SCNView!
//    var scene:SCNScene!
//    
//    var chickenNode: SCNNode!
//    var selfieStickNode:SCNNode!
//    
//    var motion = MotionHelper()
//    var motionForce = SCNVector3(x: 0, y: 0, z: 0)
//    
//    var sounds:[String:SCNAudioSource] = [:]
//    
//    override func viewDidLoad() {
//        setupScene()
//        setupNodes()
//        setupSounds()
//    }
//    
//    func setupScene(){
//        sceneView = self.view as! SCNView
//        sceneView.allowsCameraControl = true
//        scene = SCNScene(named: "art.scnassets/Stage/Scene.scn")
//        sceneView.scene = scene
//        
//        let tapRecognizer = UITapGestureRecognizer()
//        tapRecognizer.numberOfTapsRequired = 1
//        tapRecognizer.numberOfTouchesRequired = 1
//        
//        tapRecognizer.addTarget(self, action: #selector(GameViewController.sceneViewTapped(recognizer:)))
//        sceneView.addGestureRecognizer(tapRecognizer)
//    }
//    
//    func setupNodes(){
//        chickenNode = scene.rootNode.childNode(withName: "chicken", recursively: true)!
//        selfieStickNode = scene.rootNode.childNode(withName: "selfieStick", recursively: true)
//    }
//    
//    func setupSounds(){
//        let backgroundMusic = SCNAudioSource(fileNamed: "ES_Always Too Much - Spectacles Wallet and Watch.mp3")!
//        let slapSound = SCNAudioSource(fileNamed: "slap.wav")!
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
//        chickenNode.addAudioPlayer(musicPlayer)
//    }
//    @objc func sceneViewTapped (recognizer: UITapGestureRecognizer){
//        let location = recognizer.location(in: sceneView)
//        
//        let hitResults = sceneView.hitTest(location, options: nil)
//        
//        if hitResults.count > 0 {
//            let result = hitResults.first
//            if let node = result?.node{
//                if node.name == "chicken"{
//                    let jumpSound = sounds["walk"]!
//                    chickenNode.runAction(SCNAction.playAudio(jumpSound, waitForCompletion: false))
//                    chickenNode.physicsBody?.applyForce(SCNVector3(0, 4, -12), asImpulse: true)
//                }
//            }
//        }
//    }
//    override var shouldAutorotate: Bool{
//        return false
//    }
//    
//    override var prefersStatusBarHidden: Bool{
//        return true
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
//}
//
//
