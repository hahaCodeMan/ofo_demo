//
//  ShowPassCodeViewController.swift
//  ofo_demo
//
//  Created by Risen on 2017/6/18.
//  Copyright © 2017年 Risen. All rights reserved.
//

import UIKit
import SwiftyTimer
import SwiftySound

class ShowPassCodeViewController: UIViewController {
    @IBAction func backTap(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }
    @IBAction func torchBtnTap(_ sender: Any) {
        turnTorch()
       
        if isTorchOn {
            torchBtn.setImage(#imageLiteral(resourceName: "btn_unenableTorch"), for:.normal)
        } else {
            torchBtn.setImage(#imageLiteral(resourceName: "btn_enableTorch"), for: .normal)
        }
        
        isTorchOn = !isTorchOn
        
        
    }
    @IBOutlet weak var torchBtn: UIButton!
    var remindSeconds = 120
    var isTorchOn = false
    
    @IBAction func reportBtnTap(_ sender: Any) {
       
        
        
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var countDownLabel: UILabel!
    
    

    override func viewDidLoad() {
       
       
        
        super.viewDidLoad()
        

        Timer.every(1) { (timer : Timer) in
         self.remindSeconds -= 1
        print(self.remindSeconds)
       self.countDownLabel.text = self.remindSeconds.description
        if self.remindSeconds == 0
        {
            timer.invalidate()
            }
        }

        Sound.play(file: "上车前_LH.m4a")
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
