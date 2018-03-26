//
//  DataService.swift
//  BarcodeScanner
//
//  Created by Razvan Julian on 02/03/18.
//  Copyright © 2018 Razvan Julian. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class DataService {
    
    static let dataService = DataService()
    
    fileprivate(set) var TITLE_FROM_UPCITEMDB = ""
    fileprivate(set) var BRAND_FROM_UPCITEMDB = ""
    fileprivate(set) var UPC_FROM_UPCITEMDB = ""
    fileprivate(set) var DESCRIPTION_FROM_UPCITEMDB = ""
    fileprivate(set) var IMAGE_FROM_UPCITEMDB = UIImage()
    
    
    static func searchAPI(_ codeNumber: String) {
        
        // The URL we will use to get out data from upcitemdb.com
        
        let dataURL = "\(searchURL)\(codeNumber)"
        
        Alamofire.request(dataURL, method: .get)
            .responseJSON { response in
                
                var json = JSON(response.result.value!)
                
                if json["items"][0].count > 0 {
                
                let titleItem = "\(json["items"][0]["title"])"
                let brandItem = "\(json["items"][0]["brand"])"
                let upcItem = "\(json["items"][0]["upc"])"
                let descriptionItem = "\(json["items"][0]["description"])"
                
                
                var imageItem = UIImage()
                
                let imageItemURL = NSURL(string:"\(json["items"][0]["images"][0])")
                let imageItemData = NSData(contentsOf: imageItemURL! as URL)
                imageItem = UIImage(data: imageItemData as! Data)!
                
                
                self.dataService.TITLE_FROM_UPCITEMDB = titleItem
                self.dataService.BRAND_FROM_UPCITEMDB = brandItem
                self.dataService.UPC_FROM_UPCITEMDB = upcItem
                self.dataService.DESCRIPTION_FROM_UPCITEMDB = descriptionItem
                self.dataService.IMAGE_FROM_UPCITEMDB = imageItem
                
                
                    
                // Post a notification to let DetailsViewController know we have some data.
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ItemNotification"), object: nil)
                    
                }
        }
    }
}

