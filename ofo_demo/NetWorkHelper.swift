//
//  NetWorkHelper.swift
//  ofo_demo
//
//  Created by Risen on 2017/6/24.
//  Copyright © 2017年 Risen. All rights reserved.
//
import AVOSCloud
struct NetWorkHelper {
    
}

extension  NetWorkHelper{
    static func getPass(code : String, completion: @escaping (String?) -> Void)  {
        let query = AVQuery(className:"Code")
        query.whereKey("code", equalTo: code)
        query.getFirstObjectInBackground { ( code, e ) in
            if let e = e
            {
              print("出错",e.localizedDescription)
            }
            if let code  = code,
            let pass = code["pass"] as? String
        {
            completion(pass)
            }
        }
        
        
    }
}
