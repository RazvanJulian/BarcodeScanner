//
//  Item.swift
//  BarcodeScanner
//
//  Created by Razvan Julian on 02/03/18.
//  Copyright © 2018 Razvan Julian. All rights reserved.
//

import Foundation
import UIKit

class Item {
    
    fileprivate(set) var title: String!
    fileprivate(set) var brand: String!
    fileprivate(set) var upc: String!
    fileprivate(set) var description: String!
    fileprivate(set) var image: UIImage!
    
    init(titleItem: String, brandItem: String, upcItem: String, descriptionItem: String, imageItem: UIImage) {
        
        // Add a little extra text to the item information.
        
        self.title = "Title: \(titleItem)"
        self.brand = "Brand: \(brandItem)"
        self.upc = "UPC: \(upcItem)"
        self.image = imageItem
        if descriptionItem == "" {
            self.description = "There's no description for this item."
        } else {
            self.description = "Description: \(descriptionItem)"
        }
    }
}
