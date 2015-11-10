//
//  ViewController.swift
//  Kubik
//
//  Created by Kyle Lee on 11/10/15.
//  Copyright © 2015 Kyle Lee. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var monsterImg: KubikImg!
    @IBOutlet weak var foodImg: DragImg!
    @IBOutlet weak var heartImg: DragImg!
    @IBOutlet var penalty1Img: UIImageView!
    @IBOutlet var penalty2Img: UIImageView!
    @IBOutlet var penalty3Img: UIImageView!
    
    let DIM_ALPHA: CGFloat = 0.2
    let OPAQUE: CGFloat = 1.0
    let MAX_PENALTY: Int = 3
    
    var penalties: Int = 0
    var timer: NSTimer!
    var kubicHappy: Bool = false
    var currentItem: UInt32 = 0
    
    var musicPlayer: AVAudioPlayer!
    var sfxBite: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxDeath: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.foodImg.dropTarget = self.monsterImg
        self.heartImg.dropTarget = self.monsterImg
        
        self.penalty1Img.alpha = self.DIM_ALPHA
        self.penalty2Img.alpha = self.DIM_ALPHA
        self.penalty3Img.alpha = self.DIM_ALPHA
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "itemDroppedOnCharacter:", name: "onTargetDropped", object: nil)
        
        do {
            try self.musicPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("cave-music", ofType: "mp3")!))
            
            try self.sfxBite = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bite", ofType: "wav")!))
            try self.sfxHeart = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("heart", ofType: "wav")!))
            try self.sfxDeath = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("death", ofType: "wav")!))
            try self.sfxSkull = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("skull", ofType: "wav")!))
            
            self.musicPlayer.prepareToPlay()
            self.musicPlayer.play()

            self.sfxBite.prepareToPlay()
            self.sfxHeart.prepareToPlay()
            self.sfxDeath.prepareToPlay()
            self.sfxSkull.prepareToPlay()
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        self.startTimer()
    }
    
    func itemDroppedOnCharacter(notif: AnyObject) {
        self.kubicHappy = true
        self.startTimer()
        
        self.foodImg.alpha = self.DIM_ALPHA
        self.foodImg.userInteractionEnabled = false
        
        self.heartImg.alpha = self.DIM_ALPHA
        self.heartImg.userInteractionEnabled = false
        
        if self.currentItem == 0 {
            self.sfxHeart.play()
        } else {
            self.sfxBite.play()
        }
    }
    
    func startTimer() {
        if self.timer != nil {
            self.timer.invalidate()
        }
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "changeGameState", userInfo: nil, repeats: true)
        
    }
    
    func changeGameState() {
        
        if !self.kubicHappy {
            self.penalties++
            self.sfxSkull.play()
            
            if self.penalties == 1 {
                self.penalty1Img.alpha = self.OPAQUE
                self.penalty2Img.alpha = self.DIM_ALPHA
            } else if self.penalties == 2 {
                self.penalty2Img.alpha = self.OPAQUE
                self.penalty3Img.alpha = self.DIM_ALPHA
            } else if self.penalties == 3 {
                self.penalty3Img.alpha = self.OPAQUE
            } else {
                self.penalty1Img.alpha = self.DIM_ALPHA
                self.penalty2Img.alpha = self.DIM_ALPHA
                self.penalty3Img.alpha = self.DIM_ALPHA
            }
            
            if self.penalties >= self.MAX_PENALTY {
                self.gameOver()
            }
        }
        
        let rand = arc4random_uniform(2)
        
        if rand == 0 {
            self.foodImg.alpha = self.DIM_ALPHA
            self.foodImg.userInteractionEnabled = false
            
            self.heartImg.alpha = self.OPAQUE
            self.heartImg.userInteractionEnabled = true
        } else {
            self.heartImg.alpha = self.DIM_ALPHA
            self.heartImg.userInteractionEnabled = false
            
            self.foodImg.alpha = self.OPAQUE
            self.foodImg.userInteractionEnabled = true
        }
        
        self.currentItem = rand
        self.kubicHappy = false
        
    }
    
    func gameOver() {
        self.timer.invalidate()
        self.monsterImg.playDeathAnimation()
        self.sfxDeath.play()
    }

}

