//
//  ScanViewController.swift
//  ofo_demo
//
//  Created by Risen on 2017/6/11.
//  Copyright © 2017年 Risen. All rights reserved.
//

import UIKit
import swiftScan
import FTIndicator

class ScanViewController: LBXScanViewController {
    var isFlashOn = false
    
    @IBOutlet weak var flashBtn: UIButton!
    @IBAction func flashBtnTap(_ sender: Any) {
      isFlashOn = !isFlashOn
       scanObj?.changeTorch()
        
        if isFlashOn {
            flashBtn .setImage(#imageLiteral(resourceName: "btn_enableTorch_w"), for: .normal)
        }else
        {
        flashBtn.setImage(#imageLiteral(resourceName: "btn_unenableTorch_w"), for: .normal)
        
        }
        
    }
    @IBOutlet weak var pannelView: UIView!
    
    override func handleCodeResult(arrayResult: [LBXScanResult]) {
        if let result = arrayResult.first {
            let msg  = result.strScanned
            FTIndicator .setIndicatorStyle(.dark)
            FTIndicator.showToastMessage(msg)
        
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "扫码用车"
        navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
        navigationController?.navigationBar.tintColor = UIColor.white
        var style = LBXScanViewStyle()
        
        style.anmiationStyle = .NetGrid
        style.animationImage = UIImage(named: "CodeScan.bundle/qrcode_scan_part_net")
        scanStyle = style
        
       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.bringSubview(toFront: pannelView)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.barStyle = UIBarStyle.default
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
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
