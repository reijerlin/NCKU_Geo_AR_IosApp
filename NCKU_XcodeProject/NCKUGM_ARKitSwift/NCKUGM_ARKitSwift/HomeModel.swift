//
//  HomeModel.swift
//  NCKUGM_ARKitSwift
//
//  Created by reijerlin on 2019/12/18.
//  Copyright © 2019 reijerlin. All rights reserved.
//

import UIKit

protocol  HomeModelDelegate {
    
    func itemsDownloaded(details:[Detail])
}

class HomeModel: NSObject {
    
    var delegate:HomeModelDelegate?
    
    func getItems(url:String){

        if let url=URL(string: url){
            let session=URLSession(configuration: .default)
            
            let task=session.dataTask(with: url, completionHandler: {(data,response,error) in
                if error==nil{
                    //Succeeded
                    
                    //Call the parse json function on the data
                    self.parseJson(data:data!)
                }else{
                    //Error
                }
            })
            
            //Start the task
            task.resume()
        }
        //parse it out into location structs
        
        //notify the view controller and pass the data back
    }
    func parseJson(data:Data){
        
        var detailArray=[Detail]()
        
        //Parse the data into detail struct
        
        
        do{
            let jsonArray=try JSONSerialization.jsonObject(with: data, options: [])as! [Any]
            
            for jsonResult in jsonArray{
                let jsonDict = jsonResult as![String:String]
                
                let detail=Detail(applicant: jsonDict["applicant"]!, start_time: jsonDict["start_time"]!, end_time: jsonDict["end_time"]!)
                detailArray.append(detail)
            }
            
            //Pass the location array back to delegate
            delegate?.itemsDownloaded(details: detailArray)
            
        }catch{
            print("Error")
        }
        
        
    }

}
