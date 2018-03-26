//
//  DetailsViewController.swift
//  BarcodeScanner
//
//  Created by Razvan Julian on 02/03/18.
//  Copyright © 2018 Razvan Julian. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var upcLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        self.titleLabel.text = ""
        self.brandLabel.text = ""
        self.upcLabel.text = ""
        self.descriptionLabel.text = ""
        self.welcomeLabel.text = "Scan an item!"
        self.imageView.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(DetailsViewController.setLabels(_:)), name: NSNotification.Name(rawValue: "ItemNotification"), object: nil)

    }

    
    func setLabels(_ notification: Notification){
        
        // Use the data from DataService.swift to initialize the Item.
        
        let itemInfo = Item(titleItem: DataService.dataService.TITLE_FROM_UPCITEMDB,
                            brandItem: DataService.dataService.BRAND_FROM_UPCITEMDB,
                            upcItem: DataService.dataService.UPC_FROM_UPCITEMDB,
                            descriptionItem: DataService.dataService.DESCRIPTION_FROM_UPCITEMDB,
                            imageItem: DataService.dataService.IMAGE_FROM_UPCITEMDB)
        
        
        //Item(titleItem: DataService.dataService.TITLE_FROM_UPCITEMDB, brandItem: DataService.dataService.BRAND_FROM_UPCITEMDB, upcItem: DataService.dataService.UPC_FROM_UPCITEMDB)
        
        welcomeLabel.isHidden = true
        imageView.isHidden = false
        titleLabel.text = "\(itemInfo.title!)"
        brandLabel.text = "\(itemInfo.brand!)"
        upcLabel.text = "\(itemInfo.upc!)"
        descriptionLabel.text = "\(itemInfo.description!)"
        imageView.image = itemInfo.image
        
        print(titleLabel.text, brandLabel.text, upcLabel.text, descriptionLabel.text)
        
        
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
