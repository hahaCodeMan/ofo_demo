//
//  inputViewController.swift
//  ofo_demo
//
//  Created by Risen on 2017/6/14.
//  Copyright © 2017年 Risen. All rights reserved.
//

import UIKit
import APNumberPad


class inputViewController: UIViewController,APNumberPadDelegate,UITextFieldDelegate {
    @IBOutlet weak var goBtn: UIButton!
    @IBOutlet weak var intputTextField: UITextField!
    var isFlashOn = false
    var isVoiceOn = true
    
    @IBAction func voiceBtnTap(_ sender: Any) {
        isVoiceOn = !isVoiceOn
        if isVoiceOn {
         voiceBtn.setImage(#imageLiteral(resourceName: "voiceopen"), for: .normal)
        }else
        {
            voiceBtn.setImage(#imageLiteral(resourceName: "voiceclose"), for: .normal)
  
        }    }
    @IBAction func flashBtnTap(_ sender: Any) {
        isFlashOn = !isFlashOn
        if isFlashOn {
        flashBtn.setImage(#imageLiteral(resourceName: "btn_torch_disable"), for: .normal)
        }else
        {
         flashBtn.setImage(#imageLiteral(resourceName: "btn_unenableTorch"), for: .normal)
        }
    }
    @IBOutlet weak var voiceBtn: UIButton!
    @IBOutlet weak var flashBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        title  = "车辆解锁"
        goBtn.isEnabled = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "扫码用车", style: .plain, target: self, action: #selector(backToScan ))
        let numberPad = APNumberPad(delegate: self)
        numberPad.leftFunctionButton.setTitle("确定", for: .normal)
        intputTextField.inputView = numberPad
        intputTextField.delegate = self
      
        //247 215 80
   intputTextField.layer.borderWidth = 2
   //intputTextField.layer.borderColor = UIColor.yellow.cgColor
   intputTextField.layer.borderColor = UIColor.ofo.cgColor
        // Do any additional setup after loading the view.
    }
    
    func numberPad(_ numberPad: APNumberPad, functionButtonAction functionButton: UIButton, textInput: UIResponder) {
        print("点击了我")
        NetWorkHelper
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {
            return true
        }
        
        let newLength =  text.characters.count + string.characters.count - range.length
        if newLength>0 {
         goBtn .setImage(#imageLiteral(resourceName: "nextArrow_enable"), for: .normal)
            goBtn.backgroundColor = UIColor.ofo
            goBtn.isEnabled = true
        }else
        {
         goBtn.setImage(#imageLiteral(resourceName: "nextArrow_unenable"), for: .normal)
         goBtn.backgroundColor = UIColor.groupTableViewBackground
             goBtn.isEnabled = false
        }
        return newLength <= 8
        
        
        
    }
    
    func backToScan () {
     navigationController?.popViewController(animated: true)
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
