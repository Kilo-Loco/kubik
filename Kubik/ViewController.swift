//
//  ViewController.swift
//  Kubik
//
//  Created by Kyle Lee on 11/10/15.
//  Copyright © 2015 Kyle Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var monsterImg: KubikImg!
    @IBOutlet weak var foodImg: DragImg!
    @IBOutlet weak var heartImg: DragImg!
    @IBOutlet var penalty1Img: UIImageView!
    @IBOutlet var penalty2Img: UIImageView!
    @IBOutlet var penalty3Img: UIImageView!
    
    let DIM_ALPHA: CGFloat = 0.2
    let OPAQUE: CGFloat = 1.0
    let MAX_PENALTY = 3
    
    var penalties = 0
    var timer: NSTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.foodImg.dropTarget = self.monsterImg
        self.heartImg.dropTarget = self.monsterImg
        
        self.penalty1Img.alpha = self.DIM_ALPHA
        self.penalty2Img.alpha = self.DIM_ALPHA
        self.penalty3Img.alpha = self.DIM_ALPHA
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "itemDroppedOnCharacter:", name: "onTargetDropped", object: nil)
        
        self.startTimer()
    }
    
    func itemDroppedOnCharacter(notif: AnyObject) {
        
    }
    
    func startTimer() {
        if self.timer != nil {
            self.timer.invalidate()
        }
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "changeGameState", userInfo: nil, repeats: true)
        
    }
    
    func changeGameState() {
        
        self.penalties++
        
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
    
    func gameOver() {
        self.timer.invalidate()
        self.monsterImg.playDeathAnimation()
    }

}

