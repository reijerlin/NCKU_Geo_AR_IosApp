//
//  PredictResultViewController.swift
//  NCKUGM_ARKitSwift
//
//  Created by reijerlin on 2020/1/2.
//  Copyright © 2020 reijerlin. All rights reserved.
//

import UIKit
import CoreML

class PredictResultViewController: UIViewController {

    
    @IBOutlet weak var label: UILabel!
    var result = [Int]()
    var result_norm=[Double]()
    var model=Thesis3()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
        let max=result.max()
        for value in result{
            result_norm.append(Double(value)/Double(max!))
           
        }
       //print(result_norm)
        
        let mlArray = try? MLMultiArray(shape: [16], dataType: MLMultiArrayDataType.double)
        for i in 0..<result_norm.count {
             mlArray?[i] = NSNumber(value: result_norm[i])
        }
        let output=try? model.prediction(features: mlArray!)
        //print(output?.output as Any)
        /*
        let gis=output?.output["GIS"]
        
        let geo=output?.output["大地"]
        
        let rs=output?.output["遙測"]
        */
        //let str2Arr = str2!.components(separatedBy: ",")
        
        let str2=output?.output.description
        
        let str=output?.classLabel
        print(str2 as Any)
        label.text=str
        
 
    }
    
   
}
