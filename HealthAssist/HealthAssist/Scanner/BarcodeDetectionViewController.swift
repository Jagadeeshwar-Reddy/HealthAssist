//
//  BarcodeDetectionViewController.swift
//  TescoTitan
//
//  Created by Jon Hocking on 09/01/2018.
//  Copyright © 2018 Tesco. All rights reserved.
//

import UIKit
import AVFoundation

public protocol BarcodeDetectionViewControllerDelegate: class {
	
	func barcodeDetectionCameraAccessDenied()
	func barcodeDetectionCameraAccessGranted()
	func barcodeDetectionCameraDidDetectBarcode(barcode: BarcodeDetectionViewController.Barcode)
	
}

public final class BarcodeDetectionViewController: UIViewController {
    enum ScannerError: Error {
        case itemNotFound
        case restrictedItem
        case networkError
        case genericError
    }
    
	public struct Barcode {
		let type: AVMetadataObject.ObjectType
		public let contents: String
	}
	
	public weak var delegate: BarcodeDetectionViewControllerDelegate?
	
	private let captureSession: AVCaptureSession = AVCaptureSession()
	private let captureMetadataOutput = AVCaptureMetadataOutput()
	private let supportedCodeTypes: [AVMetadataObject.ObjectType] = [.upce, .code39, .code39Mod43, .code93, .code128, .ean8, .ean13, .aztec, .pdf417, .qr]
	private let videoPreviewLayer = AVCaptureVideoPreviewLayer()
	
	private let sessionQueue = DispatchQueue(label: "Serial camera session queue", qos: DispatchQoS.userInitiated, attributes: [])
	
	// MARK: -
	
	public override func viewDidLoad() {
		super.viewDidLoad()
		videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
		videoPreviewLayer.frame = view.layer.bounds
		view.layer.addSublayer(videoPreviewLayer)
	}
	
	public override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		videoPreviewLayer.frame = self.view.bounds
	}
	
	/// A rect in layer coordinates describing the area to scan for meta data. Useful to change or limit the scanning area according to a crosshair in the layer coordinates.
	public var scanningRect: CGRect {
		get {
			let metaDataRect = captureMetadataOutput.rectOfInterest
			return videoPreviewLayer.layerRectConverted(fromMetadataOutputRect: metaDataRect)
		}
		set {
			let metaDataRect = videoPreviewLayer.metadataOutputRectConverted(fromLayerRect: newValue)
			captureMetadataOutput.rectOfInterest = metaDataRect
		}
	}
	
	/// Starts the capture session and begins reporting back to the delegate on the sessionQueue if barcode data is found
	public func startDetecting() {
		captureSession.startRunning()
	}
	
	/// Stops the capture session, freezing the camera.
	public func stopDetecting() {
		captureSession.stopRunning()
	}
	
	// MARK: - Camera access
	
	public func requestCameraAccessIfNecessary() {
		AVCaptureDevice.requestAccess(for: AVMediaType.video) { [weak self] accessGranted in
			DispatchQueue.safeSyncOnMain {
				self?.handleAccessRequestResult(accessGranted)
			}
		}
	}
	
	private func handleAccessRequestResult(_ accessGranted: Bool) {
		guard accessGranted else {
			delegate?.barcodeDetectionCameraAccessDenied()
			return
		}
		do {
			try setupCaptureSession()
			delegate?.barcodeDetectionCameraAccessGranted()
		} catch {
			delegate?.barcodeDetectionCameraAccessDenied()
		}
	}
	
	// MARK: - Capture Session Setup
	
	private func setupCaptureSession() throws {
		guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
			throw ScannerError.genericError
		}
		captureSession.beginConfiguration()
		try addInput(to: captureSession, using: captureDevice)
		addOutput(to: captureSession)
		addVideoPreviewLayer(toCaptureSession: captureSession)
		captureSession.commitConfiguration()
	}
	
	private func addOutput(to captureSession: AVCaptureSession) {
		captureSession.addOutput(captureMetadataOutput)
		captureMetadataOutput.setMetadataObjectsDelegate(self, queue: sessionQueue)
		captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
	}
	
	private func addInput(to captureSession: AVCaptureSession, using captureDevice: AVCaptureDevice) throws {
		let input = try AVCaptureDeviceInput(device: captureDevice)
		captureSession.addInput(input)
	}
	
	private func addVideoPreviewLayer(toCaptureSession captureSession: AVCaptureSession) {
		videoPreviewLayer.session = captureSession
	}
	
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate

extension BarcodeDetectionViewController: AVCaptureMetadataOutputObjectsDelegate {
	
	public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
		guard let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
			supportedCodeTypes.contains(metadataObject.type),
			let barcodeString = metadataObject.stringValue else {
				return
		}
		
		let barcode = Barcode(type: metadataObject.type, contents: barcodeString)
		
		DispatchQueue.safeSyncOnMain { [weak self] in
			self?.delegate?.barcodeDetectionCameraDidDetectBarcode(barcode: barcode)
		}
	}
}
