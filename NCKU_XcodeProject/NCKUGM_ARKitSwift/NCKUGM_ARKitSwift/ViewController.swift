//
//  ViewController.swift
//  NCKUGM_ARKitSwift
//
//  Created by reijerlin on 2019/12/7.
//  Copyright © 2019 reijerlin. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class ViewController: UIViewController , ARSCNViewDelegate{
    
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var toolbar:UIToolbar!
    var ViewTime = Array(repeating: 0, count: 16)
    var start: Date?
    var end: Date?

    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.3, *) {
            resetTrackingConfiguration()
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    @available(iOS 11.3, *)
    @IBAction func resetButtonDidTouch(_ sender: UIBarButtonItem) {
          resetTrackingConfiguration()
          
      }
    
    @IBAction func done_dismiss(_ sender: Any) {
         self.dismiss(animated: true, completion: nil)
    }
    @available(iOS 11.3, *)
    func resetTrackingConfiguration() {
        
        end=Date()
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else { return }
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages
        let options: ARSession.RunOptions = [.resetTracking, .removeExistingAnchors]
        sceneView.session.run(configuration, options: options)
       
       
        let str=label.text
        

        switch str {
        case "Image detected: \"Chao-Hung Lin\"":
            ViewTime[0]+=Int(end!.timeIntervalSince1970 - start!.timeIntervalSince1970)
        case "Image detected: \"Chi-Kuei Wang\"":
            ViewTime[6]+=Int(end!.timeIntervalSince1970 - start!.timeIntervalSince1970)
        case "Image detected: \"Chih-Da Wu\"":
            ViewTime[14]+=Int(end!.timeIntervalSince1970 - start!.timeIntervalSince1970)
        case "Image detected: \"Chung-Yen Kuo\"":
            ViewTime[5]+=Int(end!.timeIntervalSince1970 - start!.timeIntervalSince1970)
        case "Image detected: \"Hone-Jay Chu\"":
            ViewTime[11]+=Int(end!.timeIntervalSince1970 - start!.timeIntervalSince1970)
        case "Image detected: \"Hong-Zeng Tseng\"":
            ViewTime[15]+=Int(end!.timeIntervalSince1970 - start!.timeIntervalSince1970)
        case "Image detected: \"Hsueh-Chan Lu\"":
            ViewTime[12]+=Int(end!.timeIntervalSince1970 - start!.timeIntervalSince1970)
        case "Image detected: \"Jaan-Rong Tsay\"":
            ViewTime[9]+=Int(end!.timeIntervalSince1970 - start!.timeIntervalSince1970)
        case "Image detected: \"Jiann-Yeou Rau\"":
            ViewTime[7]+=Int(end!.timeIntervalSince1970 - start!.timeIntervalSince1970)
        case "Image detected: \"Jung-Hong Hong\"":
            ViewTime[8]+=Int(end!.timeIntervalSince1970 - start!.timeIntervalSince1970)
        case "Image detected: \"Kai-Wei Chiang\"":
            ViewTime[4]+=Int(end!.timeIntervalSince1970 - start!.timeIntervalSince1970)
        case "Image detected: \"Kuo-En Ching\"":
            ViewTime[10]+=Int(end!.timeIntervalSince1970 - start!.timeIntervalSince1970)
        case "Image detected: \"Ming Yang\"":
            ViewTime[2]+=Int(end!.timeIntervalSince1970 - start!.timeIntervalSince1970)
        case "Image detected: \"Pei-Fen Kuo\"":
            ViewTime[13]+=Int(end!.timeIntervalSince1970 - start!.timeIntervalSince1970)
        case "Image detected: \"Rey-Jer You\"":
            ViewTime[3]+=Int(end!.timeIntervalSince1970 - start!.timeIntervalSince1970)
        case "Image detected: \"Yi-Hsing Tseng\"":
            ViewTime[1]+=Int(end!.timeIntervalSince1970 - start!.timeIntervalSince1970)
        default:
            print("Start")
        
            
        }
        
        print(ViewTime)
        label.text = "Move camera around to detect images"
        
        
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is PredictResultViewController
        {
            let vc = segue.destination as? PredictResultViewController
            vc?.result=ViewTime
        }
    }
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    
        if #available(iOS 11.3, *){
            guard let imageAnchor = anchor as? ARImageAnchor else { return }
            
            DispatchQueue.main.async {
                let physicalWidth = imageAnchor.referenceImage.physicalSize.width
                let physicalHeight = imageAnchor.referenceImage.physicalSize.height
                let referenceImage = imageAnchor.referenceImage
                let imageName = referenceImage.name ?? "no name"
                // Create a plane geometry to visualize the initial position of the detected image
                let mainPlane = SCNPlane(width: physicalWidth, height: physicalHeight)
                mainPlane.firstMaterial?.colorBufferWriteMask = .alpha
                
                // Create a SceneKit root node with the plane geometry to attach to the scene graph
                // This node will hold the virtual UI in place
                let mainNode = SCNNode(geometry: mainPlane)
                mainNode.eulerAngles.x = -.pi / 2
                mainNode.renderingOrder = -1
                mainNode.opacity = 1
                
                // Add the plane visualization to the scene
                node.addChildNode(mainNode)
                
                // Perform a quick animation to visualize the plane on which the image was detected.
                // We want to let our users know that the app is responding to the tracked image.
                let professors = ["Chao-Hung Lin","Chi-Kuei Wang","Chih-Da Wu","Chung-Yen Kuo","Hone-Jay Chu","Hong-Zeng Tseng","Hsueh-Chan Lu","Jaan-Rong Tsay","Jiann-Yeou Rau","Jung-Hong Hong","Kai-Wei Chiang","Kuo-En Ching","Ming Yang","Pei-Fen Kuo","Rey-Jer You","Yi-Hsing Tseng"]
                if professors.contains(imageName){
                    self.highlightDetection(on: mainNode, width: physicalWidth, height: physicalHeight, completionHandler: {
                        self.displayPortraitView(on: mainNode, xOffset: physicalWidth,img:imageName)
                        self.displayDetailView(on: mainNode, xOffset: physicalWidth,img:imageName)
                    })
                }else{
                    self.highlightDetection(on: mainNode, width: physicalWidth, height: physicalHeight, completionHandler: {
                        self.displayRentDetail(on: mainNode, xOffset: physicalWidth,img:imageName)
                        
                    })
                }
               
                self.label.text = "Image detected: \"\(imageName)\""
            }
        }else{
            
        }
    }
    func displayRentDetail(on rootNode: SCNNode, xOffset: CGFloat,img:String){
        
        
        
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let ymd = formatter.string(from: today)
        //let ymd="2020-01-06"
        //let place="會客室"
        let place=img
        let originUrl="http://gisweb.tk/~pcroom/iosConnect.php?ymd="+ymd+"&place="+place
        let newUrl = originUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        var detailArray=[Detail]()
        if let url = URL(string: newUrl) {
            let session=URLSession(configuration: .default)
            let task=session.dataTask(with: url, completionHandler: {(data,response,error) in
                if error==nil{
                //Succeeded
                //Call the parse json function on the data
                    //Parse the data into detail struct
                    do{
                        let jsonArray=try JSONSerialization.jsonObject(with: data!, options: [])as! [Any]
                        
                        for jsonResult in jsonArray{
                            let jsonDict = jsonResult as![String:String]
                                       
                            let detail=Detail(applicant: jsonDict["applicant"]!, start_time: jsonDict["start_time"]!, end_time: jsonDict["end_time"]!)
                            //print(detail["start_time"])
                            detailArray.append(detail)
                        }
                        
                    }catch{
                            print("Error")
                    }
                    var Array=[String]()
                    for item in detailArray{
                        let applicant=item.applicant
                        let start=item.start_time
                        let index_s = start.index(start.startIndex, offsetBy: 5)
                        let mySubstring = start[..<index_s] // Hello
                        let st=String(mySubstring)
                        let end=item.end_time
                        let index_e = end.index(end.startIndex, offsetBy: 5)
                        let mySubstring2 = end[..<index_e] // Hello
                        let et=String(mySubstring2)
                        let str=applicant+" "+st+"~"+et
                        Array.append(str)
                    }
                    var ALL=""
                    if Array.count==0 {
                        ALL="No Schedule!"
                    }else{
                        for text in Array{
                            ALL+=text
                            ALL+="\n"
                        }
                    }
                    let rent_details=SCNText(string: ALL, extrusionDepth: 1)
                    let material=SCNMaterial()
                    material.diffuse.contents=UIColor.blue
                    material.diffuse.contentsTransform = SCNMatrix4MakeScale(1,-1,1)
                    material.diffuse.wrapT=SCNWrapMode.repeat // or translate contentsTransform by (0,1,0)
                    rent_details.materials=[material]
                    
                    
                    let textNode = SCNNode()
                    textNode.position=SCNVector3(x:0.02,y:0.02,z:3)
                    textNode.scale = SCNVector3Make(-0.02,-0.02,0.02)
                    //textNode.scale=SCNVector3(x:0.02,y:0.02,z:0.02)
                    textNode.geometry = rent_details
                    /*let rotateOne = SCNAction.rotateBy(x: 0, y: CGFloat(Float.pi), z: 0, duration: 5.0)
                     
                    let repeatForever = SCNAction.repeatForever(rotateOne) // to rotate the object continuously without hovering
                    textNode.runAction(repeatForever) // here node is your virtual object*/
                    rootNode.addChildNode(textNode)
                    /*     textNode.runAction(.sequence([
                             .wait(duration: 0.5)/*,
                             .fadeOpacity(to: 1.0, duration: 1.5),
                             .moveBy(x: 0, y: -2, z: 0, duration: 1.5),*/
                             
                             ])
                         )*/
                    
                }else{
                    //Error
                }
        })
                       
            //Start the task
            task.resume()
        }
        
    }
    func displayPortraitView(on rootNode: SCNNode, xOffset: CGFloat,img:String) {
    
            start=Date()
            var portrait_name=""
            let image_name=img
            switch image_name {
            case "Chao-Hung Lin":
                portrait_name="Lin_P"
            case "Chi-Kuei Wang":
                portrait_name="Wang_P"
            case "Chih-Da Wu":
                portrait_name="Wu_P"
            case "Chung-Yen Kuo":
                portrait_name="Kuo_C_P"
            case "Hone-Jay Chu":
                portrait_name="Chu_P"
            case "Hong-Zeng Tseng":
                portrait_name="Tseng_H_P"
            case "Hsueh-Chan Lu":
                portrait_name="Lu_P"
            case "Jaan-Rong Tsay":
                portrait_name="Tsay_P"
            case "Jiann-Yeou Rau":
                portrait_name="Rau_P"
            case "Jung-Hong Hong":
                portrait_name="Hong_P"
            case "Kai-Wei Chiang":
                portrait_name="Chiang_P"
            case "Kuo-En Ching":
                portrait_name="Ching_P"
            case "Ming Yang":
                portrait_name="Yang_P"
            case "Pei-Fen Kuo":
                portrait_name="Kuo_P_P"
            case "Rey-Jer You":
                portrait_name="You_P"
            case "Yi-Hsing Tseng":
                portrait_name="Tseng_Y_P"
            default:
                print("Error")
            
                
            }
            let image = UIImage(named: portrait_name)

            let texture = SKTexture(image: image!)
            let imagePlane = SCNPlane(width: xOffset, height: xOffset * 1.4)
            imagePlane.cornerRadius = 0.25
            
            let imageNode = SCNNode(geometry: imagePlane)
            imageNode.geometry?.firstMaterial?.diffuse.contents = texture

        
            // Due to the origin of the iOS coordinate system, SCNMaterial's content appears upside down, so flip the y-axis.
            imageNode.geometry?.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)
            imageNode.position.z -= 0.5
            imageNode.opacity = 0
        
            rootNode.addChildNode(imageNode)
            imageNode.runAction(.sequence([
                .wait(duration: 0.5),
                .fadeOpacity(to: 1.0, duration: 1.5),
                .moveBy(x: xOffset * -1.1, y: 0, z: -0.05, duration: 1.5),
                .moveBy(x: 0, y: 0, z: -0.05, duration: 0.2)
                ])
            )
        
    }

    func displayDetailView(on rootNode: SCNNode, xOffset: CGFloat,img:String) {
          let image = UIImage(named: "Lu_D")
          let texture = SKTexture(image: image!)
          let detailPlane = SCNPlane(width: xOffset, height: xOffset * 1.4)
          detailPlane.cornerRadius = 0.25
          
          let detailNode = SCNNode(geometry: detailPlane)
          detailNode.geometry?.firstMaterial?.diffuse.contents = texture
          
          // Due to the origin of the iOS coordinate system, SCNMaterial's content appears upside down, so flip the y-axis.
          detailNode.geometry?.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)
          detailNode.position.z -= 0.5
          detailNode.opacity = 0
          
          rootNode.addChildNode(detailNode)
          detailNode.runAction(.sequence([
            .wait(duration: 1.5),
              .fadeOpacity(to: 1.0, duration: 1.5),
              .moveBy(x: xOffset * 1.1, y: 0, z: -0.05, duration: 1.5),
              .moveBy(x: 0, y: 0, z: -0.05, duration: 0.2)
              ])
          )
      }
   
      func highlightDetection(on rootNode: SCNNode, width: CGFloat, height: CGFloat, completionHandler block: @escaping (() -> Void)) {
          let planeNode = SCNNode(geometry: SCNPlane(width: width, height: height))
          planeNode.geometry?.firstMaterial?.diffuse.contents = UIColor.white
          planeNode.position.z += 0.1
          planeNode.opacity = 0
          
          rootNode.addChildNode(planeNode)
          planeNode.runAction(self.imageHighlightAction) {
              block()
          }
      }
      
      var imageHighlightAction: SCNAction {
          return .sequence([
              .wait(duration: 0.25),
              .fadeOpacity(to: 0.85, duration: 0.25),
              .fadeOpacity(to: 0.15, duration: 0.25),
              .fadeOpacity(to: 0.85, duration: 0.25),
              .fadeOut(duration: 0.5),
              .removeFromParentNode()
              ])
      }
      /*func displayWebView(on rootNode: SCNNode, xOffset: CGFloat) {
           // Xcode yells at us about the deprecation of UIWebView in iOS 12.0, but there is currently
           // a bug that does now allow us to use a WKWebView as a texture for our webViewNode
           // Note that UIWebViews should only be instantiated on the main thread!

          DispatchQueue.main.async {
             
               let request = URLRequest(url: URL(string: "https://www.worldwildlife.org/species/african-elephant#overview")!)
              let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: 500, height: 800))
              webView.load(request)
                           
               let webViewPlane = SCNPlane(width: xOffset, height: xOffset * 1.4)
               webViewPlane.cornerRadius = 0.25
               
               let webViewNode = SCNNode(geometry: webViewPlane)
               webViewNode.geometry?.firstMaterial?.diffuse.contents = webView
               webViewNode.position.z -= 0.5
               webViewNode.opacity = 0
               
               rootNode.addChildNode(webViewNode)
               webViewNode.runAction(.sequence([
                  .wait(duration: 3.0),
                   .fadeOpacity(to: 1.0, duration: 1.5),
                   .moveBy(x: xOffset * 1.1, y: 0, z: -0.05, duration: 1.5),
                   .moveBy(x: 0, y: 0, z: -0.05, duration: 0.2)
                   ])
               )
           }
          /*DispatchQueue.main.async {
              let request = URLRequest(url: URL(string: "https://www.worldwildlife.org/species/african-elephant#overview")!)
              let webView = UIWebView(frame: CGRect(x: 0, y: 0, width: 400, height: 672))
              webView.loadRequest(request)
                          
              let webViewPlane = SCNPlane(width: xOffset, height: xOffset * 1.4)
              webViewPlane.cornerRadius = 0.25
              
              let webViewNode = SCNNode(geometry: webViewPlane)
              webViewNode.geometry?.firstMaterial?.diffuse.contents = webView
              webViewNode.position.z -= 0.5
              webViewNode.opacity = 0
              
              rootNode.addChildNode(webViewNode)
              webViewNode.runAction(.sequence([
                  .wait(duration: 3.0),
                  .fadeOpacity(to: 1.0, duration: 1.5),
                  .moveBy(x: xOffset * 1.1, y: 0, z: -0.05, duration: 1.5),
                  .moveBy(x: 0, y: 0, z: -0.05, duration: 0.2)
                  ])
              )
          }*/
       }*/
    
    
}


