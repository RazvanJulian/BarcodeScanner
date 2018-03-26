//
//  ScannerViewController.swift
//  BarcodeScanner
//
//  Created by Razvan Julian on 02/03/18.
//  Copyright © 2018 Razvan Julian. All rights reserved.
//

import UIKit
import AVFoundation

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet var scanButton: UIBarButtonItem!
    @IBOutlet var textField: UITextField!
    
    
    
    
    var session: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        // Create a session object.
        
        session = AVCaptureSession()
        
        // Set the captureDevice.
        
        let videoCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        // Create input object.
        
        let videoInput: AVCaptureDeviceInput?
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        // Add input to the session.
        
        if (session.canAddInput(videoInput)) {
            session.addInput(videoInput)
        } else {
            scanningNotPossible()
        }
        
        // Create output object.
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        // Add output to the session.
        
        if (session.canAddOutput(metadataOutput)) {
            session.addOutput(metadataOutput)
            
            // Send captured data to the delegate object via a serial queue.
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            // Set barcode type for which to scan: EAN-13.
            
            metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeEAN13Code]
            
        } else {
            scanningNotPossible()
        }
        
        // Add previewLayer and have it show the video data.
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session);
        previewLayer.frame = CGRect(x: view.layer.bounds.minX, y: 150, width: view.layer.bounds.width, height: view.layer.bounds.height)//view.layer.bounds;
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        view.layer.addSublayer(previewLayer);
        
        // Begin the capture session.
        
        session.startRunning()

        
        
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (session?.isRunning == false) {
            session.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (session?.isRunning == true) {
            session.stopRunning()
        }
    }

    
    
    func scanningNotPossible() {
        
        // Let the user know that scanning isn't possible with the current device.
        
        let alert = UIAlertController(title: "Warning", message: "This device has no camera!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        session = nil
        
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        // Get the first object from the metadataObjects array.
        
        if let barcodeData = metadataObjects.first {
            
            // Turn it into machine readable code
            
            let barcodeReadable = barcodeData as? AVMetadataMachineReadableCodeObject;
            
            if let readableCode = barcodeReadable {
                
                // Send the barcode as a string to barcodeDetected()
                
                barcodeDetected(readableCode.stringValue);
            }
            
            // Vibrate the device to give the user some feedback.
            
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            // Avoid a very buzzy device.
            
            session.stopRunning()
        }
    }
    
    func barcodeDetected(_ code: String) {
        
        // Let the user know we've found something.
        
        let alert = UIAlertController(title: "Barcode Found!", message: code, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: { action in
            
            // Remove the spaces.
            
            let trimmedCode = code.trimmingCharacters(in: CharacterSet.whitespaces)
            
            // EAN or UPC?
            // Check for added "0" at beginning of code.
            
            let trimmedCodeString = "\(trimmedCode)"
            var trimmedCodeNoZero: String
            
            if trimmedCodeString.hasPrefix("0") && trimmedCodeString.characters.count > 1 {
                trimmedCodeNoZero = String(trimmedCodeString.characters.dropFirst())
                
                // Send the doctored UPC to DataService.searchAPI()
                
                DataService.searchAPI(trimmedCodeNoZero)
            } else {
                
                // Send the doctored EAN to DataService.searchAPI()
                
                DataService.searchAPI(trimmedCodeString)
            }
            
            self.navigationController?.popViewController(animated: true)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }

    
    @IBAction func scanAction(_ sender: AnyObject) {
        
        if textField.text != "" {
            barcodeDetected(self.textField.text!)
        }
        
        
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
