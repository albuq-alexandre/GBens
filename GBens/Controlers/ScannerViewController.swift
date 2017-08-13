//
//  ScannerViewController.swift
//  GBens
//
//  Created by Alexandre de Sousa Albuquerque on 10/05/17.
//  Copyright © 2017 Alexandre de Sousa Albuquerque. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class ScannerViewController: UIViewController {

    @IBAction func unwindToScanner(segue: UIStoryboardSegue) {
    }
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var tqrCodeFrameView: UIView?
    @IBOutlet weak var qrCodeFrameView: UIView!
    @IBOutlet weak var labelStatus: UILabel!
    var capturedBem: Bem?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()
        
        let videoCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            
            falha()
            return
            
        }
        
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeAztecCode, AVMetadataObjectTypePDF417Code]
            
        } else {
            
            falha()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer (session: captureSession)
        previewLayer?.frame = view.layer.bounds
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        qrCodeFrameView.layer.addSublayer(previewLayer!)
        
        
        captureSession.startRunning()
        
        // Initialize QR Code Frame to highlight the QR code
        tqrCodeFrameView = UIView()
        
        if let tqrCodeFrameView = tqrCodeFrameView {
            tqrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            tqrCodeFrameView.layer.borderWidth = 3
            qrCodeFrameView.addSubview(tqrCodeFrameView)
            qrCodeFrameView.bringSubview(toFront: tqrCodeFrameView)
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning();
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning();
        }
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
       
        
        if metadataObjects == nil || metadataObjects.count == 0 {
            tqrCodeFrameView?.frame = CGRect.zero
            labelStatus.text = "***Sem Detecção***"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
       // if metadataObj.type == AVMetadataObjectTypeEAN13Code {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = previewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                labelStatus.text = metadataObj.stringValue
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                found(code: metadataObj.stringValue)
                //print(metadataObj.type)
        //    }
        
        
            
        }
        
        dismiss(animated: true)
    }
    
    func found(code: String) {
        
        
        labelStatus.text = code
        
       // let codeStartIndex = code.index((code.startIndex), offsetBy: 1)..<code.index((code.endIndex), offsetBy: -1)


        let bemCoded = calcCodBem(code: code)
        

        let managedContext = (UIApplication.shared.delegate as! GBensAppDelegate).persistentContainer.viewContext
        
        let fetchRequest : NSFetchRequest<Bem> = Bem.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "codBem", ascending: true , selector: #selector(NSString.localizedStandardCompare(_:)))]
        fetchRequest.fetchBatchSize = 1
        fetchRequest.predicate = NSPredicate(format: "nrCodBem == %@", bemCoded, ["","",""])
        
        var fetchedBem : [Bem]
        do {
            
            fetchedBem = try managedContext.fetch(fetchRequest)
            
        } catch {
            
            fatalError("Falha ao encontrar BEM: \(error)")
            
        }
        
        if fetchedBem.count != 0 {
            captureSession.stopRunning()
            capturedBem = fetchedBem.first
            capturedBem?.scan_date = Date() as NSDate
            self.performSegue(withIdentifier: "scannerToDetails", sender: nil)
            
            
        }
        //print (fetchedBem.first?.codBem! as Any)
        
        
        
//        let alertController = UIAlertController(title: "Sucesso", message: "Bem Lido \(fetchedBem.first?.codBem ?? bemCoded)", preferredStyle: .alert)
//        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//        alertController.addAction(defaultAction)
//        self.present(alertController, animated: true, completion: nil)

        //code?.stringByReplacingOccurrencesOfString("[^0-9]", withString: "", options: NSString.CompareOptions.RegularExpressionSearch, range:nil).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        

        
        
        
    }
    
    func calcCodBem (code: String?) -> String {
        
        var codes: String = "0"
        
        if code == nil {
            codes = "0"
        } else {
        
        let coden = Int((code?.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression))!)
        codes = "\(coden ?? 0)"
            
        }
        print(codes)
        return codes
        
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    
    
    func falha() {
        
        let alerta = UIAlertController (title: "Leitura não Suportada", message: "Dispositivo não suportado. Use um dispositivo com câmera", preferredStyle: .alert)
        
        alerta.addAction(UIAlertAction(title: "OK", style: .default ))
        present(alerta, animated: true)
        captureSession = nil
        
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let identifier = segue.identifier{
            switch identifier {
            case "scannerToDetails":
                (segue.destination as! BemViewController)._bem = capturedBem
                (segue.destination as! BemViewController)._dep = capturedBem?.dep_owner
                (segue.destination as! BemViewController)._loc = capturedBem?.place
                (segue.destination as! BemViewController).buttonSave.isEnabled = false
            default:
                break;
            }
        }

    
    }
    

}

extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    
}
