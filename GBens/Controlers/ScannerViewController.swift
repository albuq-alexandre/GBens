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
            metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypePDF417Code]
            
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
       // captureSession.stopRunning()
        
        if metadataObjects == nil || metadataObjects.count == 0 {
            tqrCodeFrameView?.frame = CGRect.zero
            //messageLabel.text = "No QR code is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = previewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                found(code: metadataObj.stringValue)
            }
        
        
            
        }
        
        dismiss(animated: true)
    }
    
    func found(code: String) {
        let fetchRequest : NSFetchRequest<Bem> = Bem.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "codBem", ascending: true , selector: #selector(NSString.localizedStandardCompare(_:)))]
        fetchRequest.fetchBatchSize = 1
        fetchRequest.predicate = NSPredicate(format: "codBem == %@", code, ["","",""])
        
        var fetchedBem : [Bem]
        do {
            
            fetchedBem = try fetchRequest.execute()
            
        } catch {
            
            fatalError("Falha ao encontrar usuário: \(error)")
            
        }
        
        let alertController = UIAlertController(title: "Sucesso", message: "Bem Lido \(fetchedBem.first?.codBem ?? "nada")", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)

        
        
        
        
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    
}
