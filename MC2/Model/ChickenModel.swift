//
//  ChickenModel.swift
//  MC2
//
//  Created by Evelyn Callista Yaurentius on 30/05/24.
//

import Foundation

struct ChickenModel{
    var isWalk: Bool
    var jumpCount: Float
    var slapVoice: [SlapVoice]
    var backgroundSound: String
    var footstepSound: String
    
    init(isWalk: Bool, jump: Float, slapVoice: [SlapVoice], backgroundSound: String, footstepSound: String) {
        self.isWalk = isWalk
        self.jumpCount = jump
        self.slapVoice = slapVoice
        self.backgroundSound = backgroundSound
        self.footstepSound = footstepSound
    }
    enum SlapVoice: String{
        case slap1 = "Slap1.mp3"
        case slap2 = "Slap2.mp3"
        case slap3 = "Slap3.mp3"
    }
}

class ChickenPlayerData {
    var playerChicken: ChickenModel = ChickenModel(isWalk: false, jump: 20, slapVoice: [.slap1, .slap2, .slap3], backgroundSound: "ES_Always Too Much - Spectacles Wallet and Watch.mp3", footstepSound: "footstep chicken.mp3")
}
