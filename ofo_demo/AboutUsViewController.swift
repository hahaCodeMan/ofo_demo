//
//  AboutUsViewController.swift
//  ofo_demo
//
//  Created by Risen on 2017/5/31.
//  Copyright © 2017年 Risen. All rights reserved.
//

import UIKit
import SWRevealViewController

class AboutUsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let revealVc = revealViewController() {
            revealVc.rearViewRevealWidth = 280
            navigationItem.leftBarButtonItem?.target = revealVc
            navigationItem.leftBarButtonItem?.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(revealVc.panGestureRecognizer())
        }
        
        


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
