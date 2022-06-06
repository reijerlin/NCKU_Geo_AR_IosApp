//
//  LoadingViewController.swift
//  NCKUGM_ARKitSwift
//
//  Created by reijerlin on 2019/12/8.
//  Copyright © 2019 reijerlin. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var wellcome: UILabel!
    var isRed = false
    var progressBarTimer: Timer!
    var isRunning = false
    
    
    @IBAction func btnStart_dismiss(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        btnStart.isHidden=true
        btnStart.isEnabled=false
        wellcome.isHidden=true
       
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        if #available(iOS 11.3, *) {
            
            if CheckInternet.Connection() {
                btnStart.isHidden=false
                btnStart.isEnabled=true
                wellcome.isHidden=false
                
            }else{
                self.Alert(Message: "Internet is required. Please check your internet connection!")
            }
        } else {
            self.Alert(Message: "ARKit require ios 11.3 or later! Please upgrade your ios version!")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func Alert (Message: String){
        
        let alert = UIAlertController(title: "Alert", message: Message, preferredStyle: UIAlertController.Style.alert)
        let alertAction = UIAlertAction( title : "OK" ,
        style : UIAlertAction.Style.default) { action in
            exit(0)
        }
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }
}
