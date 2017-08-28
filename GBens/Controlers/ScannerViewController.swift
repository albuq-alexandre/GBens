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

    
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var tqrCodeFrameView: UIView?
    @IBOutlet weak var qrCodeFrameView: UIView!
    @IBOutlet weak var labelStatus: UILabel!
    var capturedBem: Bem?
    
    @IBAction func unwindToScanner(segue: UIStoryboardSegue) {
      
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()
        
        let videoCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        let videoInput: AVCaptureDeviceInput
        labelStatus.text = "***Sem Detecção***"
        
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
        previewLayer.frame = qrCodeFrameView.layer.bounds
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewLayer.connection.videoOrientation = AVCaptureVideoOrientation.portrait
        previewLayer.removeAllAnimations()
        
        qrCodeFrameView.layer.addSublayer(previewLayer!)
        
        
        
        // Initialize QR Code Frame to highlight the QR code
        tqrCodeFrameView = UIView()
        
        if let tqrCodeFrameView = tqrCodeFrameView {
            tqrCodeFrameView.layer.borderColor = UIColor.red.cgColor
            tqrCodeFrameView.layer.borderWidth = 3
            qrCodeFrameView.addSubview(tqrCodeFrameView)
            qrCodeFrameView.bringSubview(toFront: tqrCodeFrameView)
            
        }
        
        captureSession.startRunning()

        
        
    }

    func updateVideoOrientation() {
        guard let previewLayer = self.previewLayer else {
            return
        }
        guard previewLayer.connection.isVideoOrientationSupported else {
            print("isVideoOrientationSupported is false")
            return
        }
        
        let statusBarOrientation = UIApplication.shared.statusBarOrientation
        let videoOrientation: AVCaptureVideoOrientation = statusBarOrientation.videoOrientation ?? .portrait
        
        if previewLayer.connection.videoOrientation == videoOrientation {
            print("no change to videoOrientation")
            return
        }
        
        previewLayer.frame = qrCodeFrameView.layer.bounds
        previewLayer.connection.videoOrientation = videoOrientation
        previewLayer.removeAllAnimations()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: nil, completion: { [weak self] (context) in
            DispatchQueue.main.async(execute: {
                self?.updateVideoOrientation()
            })
        })
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
            previewLayer.frame = qrCodeFrameView.layer.bounds
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
        
      
            let barCodeObject = previewLayer?.transformedMetadataObject(for: metadataObj)
            tqrCodeFrameView?.frame = barCodeObject!.bounds
        
            if metadataObj.stringValue != nil {
                labelStatus.text = metadataObj.stringValue
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                AudioServicesPlaySystemSound(SystemSoundID( 1006))
                found(code: metadataObj.stringValue)
                
        
            
        }
        
        dismiss(animated: true)
    }
    
    func found(code: String) {
        
        
        labelStatus.text = code
        
       // let codeStartIndex = code.index((code.startIndex), offsetBy: 1)..<code.index((code.endIndex), offsetBy: -1)
        tqrCodeFrameView?.frame = CGRect.zero
       

        let bemCoded = calcCodBem(code: code)
        

        //let managedContext = (UIApplication.shared.delegate as! GBensAppDelegate).persistentContainer.viewContext
        
        let fetchRequest : NSFetchRequest<Bem> = Bem.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "codBem", ascending: true , selector: #selector(NSString.localizedStandardCompare(_:)))]
        fetchRequest.fetchBatchSize = 20
        fetchRequest.predicate = NSPredicate(format: "nrCodBem == %@", bemCoded, ["","",""])
        
        var fetchedBem : [Bem]
        do {
            
            fetchedBem = try (UIApplication.shared.delegate as! GBensAppDelegate).persistentContainer.viewContext.fetch(fetchRequest)
            
        } catch {
            
            fatalError("Falha ao encontrar BEM: \(error)")
            
        }
        
        if fetchedBem.count != 0 {
            captureSession.stopRunning()
            capturedBem = fetchedBem.first
            capturedBem?.scan_date = Date() as NSDate
            self.performSegue(withIdentifier: "scannerToDetails", sender: nil)
            
            
        }
        
        
    }
    
    func calcCodBem (code: String?) -> String {
        
        var codes: String = "0"
        
        if code == nil {
            codes = "0"
        } else {
        
        let coden = Int((code?.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression))!)
        codes = "\(coden ?? 0)"
            
        }
        //print(codes)
        return codes
        
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    //    return .portrait
   // }

    
    
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

extension UIInterfaceOrientation {
    var videoOrientation: AVCaptureVideoOrientation? {
        switch self {
        case .portraitUpsideDown: return .portraitUpsideDown
        case .landscapeRight: return .landscapeRight
        case .landscapeLeft: return .landscapeLeft
        case .portrait: return .portrait
        default: return nil
        }
    }
}
