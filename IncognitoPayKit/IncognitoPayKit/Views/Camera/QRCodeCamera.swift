//
//  QRCodeCamera.swift
//  IncognitoPayKit
//
//  Created by Andreas Reuter on 28.11.20.
//  Copyright © 2020 NO DANCE MONKEY. All rights reserved.
//

import AVFoundation
import UIKit

class QRCodeCamera: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
  var captureSession: AVCaptureSession!

  override var prefersStatusBarHidden: Bool {
    return true
  }

  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .portrait
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor.black
    captureSession = AVCaptureSession()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
      print("Incognito pay abort to initialise QR code camera.")
      failed()
      return
    }
    
    let videoInput: AVCaptureDeviceInput
    
    do {
      videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
    } catch {
      return
    }
    
    if (captureSession.canAddInput(videoInput)) {
      captureSession.addInput(videoInput)
    } else {
      failed()
      return
    }
    
    let metadataOutput = AVCaptureMetadataOutput()

    if (captureSession.canAddOutput(metadataOutput)) {
      captureSession.addOutput(metadataOutput)

      metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
      metadataOutput.metadataObjectTypes = [.qr]
    } else {
      failed()
      return
    }
    
    let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    previewLayer.frame = view.layer.bounds
    previewLayer.videoGravity = .resizeAspectFill
    view.layer.addSublayer(previewLayer)

    captureSession.startRunning()
    
    /*
     * draw QR code corner frame, align to center of screen.
     */
    self.cornerFrame()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    if (captureSession?.isRunning == false) {
      captureSession.startRunning()
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    if (captureSession?.isRunning == true) {
      captureSession.stopRunning()
    }
  }
  
  private func cornerFrame() {
    let cornerWidth: CGFloat = 300
    let cornerHeight: CGFloat = 300
    let cornerX: CGFloat = view.bounds.size.width / 2 - cornerWidth / 2
    let cornerY: CGFloat = view.bounds.size.height / 2 - cornerHeight / 2
    let cornerView = CornerView(
      frame: CGRect(
        x: cornerX, y: cornerY,
        width: cornerWidth, height: cornerHeight
      )
    )
    view.addSubview(cornerView)
    view.bringSubviewToFront(cornerView)
  }
  
  func failed() {
    let alert = UIAlertController(
      title: "QR code camera",
      message: "QR code camera cannot start. Please use a device with a camera.",
      preferredStyle: .alert
    )
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    present(alert, animated: true)
    captureSession = nil
  }
  
  func metadataOutput(
    _ output: AVCaptureMetadataOutput,
    didOutput metadataObjects: [AVMetadataObject],
    from connection: AVCaptureConnection
  ) {
    captureSession.stopRunning()

    if let metadataObject = metadataObjects.first {
      guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else {
        print("Incognito pay cannot read QR code.")
        return
      }
      
      guard let stringValue = readableObject.stringValue else {
        print("Incognito pay cannot convert QR code value.")
        return
      }
      
      AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
      found(code: stringValue)
    }

    dismiss(animated: true)
  }

  func found(code: String) {
    print(code)
  }
}
