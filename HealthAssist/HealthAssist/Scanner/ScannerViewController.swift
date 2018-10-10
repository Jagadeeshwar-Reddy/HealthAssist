//
//  ScannerViewController.swift
//  HealthAssist
//
//  Created by Jagadeeshwar Reddy on 12/07/18.
//  Copyright © 2018 Tesco. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire

public final class ScannerViewController: UIViewController {
    @IBOutlet private var messageLabel: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var blackoutView: UIView!
    @IBOutlet private var crosshairView: CrosshairView!
    @IBOutlet private var cameraContainerView: UIView!
    @IBOutlet private var itemScannedView: UIView!
    
    private let scanningAreaPadding: CGFloat = 100
    private let barcodeDetectionViewController = BarcodeDetectionViewController()
    

    override public func viewDidLoad() {
        super.viewDidLoad()
        setupActivityIndicator()
        setupBarcodeDetectionView()
        setupInitialState()
        setupGestures()
        title = "Scan a barcode"
    }
    
    private func setupInitialState() {
        show(view: blackoutView, shouldShow: true, animated: false)
        show(view: crosshairView, shouldShow: true)
    }
    
    @objc private func resumeScanning() {
        if itemScannedView.isHidden {
            return
        }
        let animator = CardAnimator(viewToAnimate: itemScannedView, presentingView: view, supplementaryView: blackoutView)
        animator.dismiss {
            self.moveToScanningState()
        }
    }
    
    private func setupGestures() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(resumeScanning))
        blackoutView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func moveToScanningState() {
        show(view: blackoutView, shouldShow: false)
        show(view: crosshairView, shouldShow: true)
        
        activityIndicator.stopAnimating()
        barcodeDetectionViewController.startDetecting()
        setupScanningArea()
        messageLabel.text = "Position the barcode in the frame above"
    }
    
    private func moveToFindingItemState() {
        show(view: blackoutView, shouldShow: true)
        show(view: crosshairView, shouldShow: false)
        
        activityIndicator.startAnimating()
        barcodeDetectionViewController.stopDetecting()
        messageLabel.text = nil
    }
    
    func moveToItemFoundState(withProduct product: Product) {
        show(view: blackoutView, shouldShow: true)
        show(view: crosshairView, shouldShow: false)
        activityIndicator.stopAnimating()
        messageLabel.text = "Tap screen to return to scanning"
        
        itemScannedView.addContainedSubview(productContentView(for: product))
        let animator = CardAnimator(viewToAnimate: itemScannedView, presentingView: view, supplementaryView: blackoutView)
        animator.present {
            debugPrint("presented")
        }
    }
    
    private func productContentView(for product: Product) -> ProductContentView {
        let contentView = ProductContentView.loadFromNib()
        contentView.configure(with: product)
        contentView.layoutIfNeeded()
        return contentView
    }
    
    private func setupActivityIndicator() {
        activityIndicator.stopAnimating()
    }
    
    private func setupBarcodeDetectionView() {
        barcodeDetectionViewController.loadViewIfNeeded()
        cameraContainerView.addContainedSubview(barcodeDetectionViewController.view)
        barcodeDetectionViewController.delegate = self
        barcodeDetectionViewController.requestCameraAccessIfNecessary()
        setupScanningArea()
    }
    
    private func setupScanningArea() {
        let frameInCameraView = barcodeDetectionViewController.view.convert(crosshairView.frame, from: crosshairView.superview)
        barcodeDetectionViewController.scanningRect = frameInCameraView.insetBy(dx: -scanningAreaPadding, dy: -scanningAreaPadding)
    }
    
    private func show(view: UIView, shouldShow: Bool, animated: Bool = true) {
        let animations: () -> Void = {
            view.alpha = shouldShow ? 1 : 0
        }
        
        if !animated {
            animations()
            return
        }
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .beginFromCurrentState, animations: animations)
    }
}

// MARK: - BarcodeDetectionViewControllerDelegate

extension ScannerViewController: BarcodeDetectionViewControllerDelegate {
    
    public func barcodeDetectionCameraAccessDenied() {
    }
    
    public func barcodeDetectionCameraAccessGranted() {
        moveToScanningState()
    }
    
    public func barcodeDetectionCameraDidDetectBarcode(barcode: BarcodeDetectionViewController.Barcode) {
        moveToFindingItemState()
        print(barcode.contents)
        Mango.searchForProduct(barcode: barcode.contents) { [weak self] product in
            if let scannedProduct = product {
                self?.moveToItemFoundState(withProduct: scannedProduct)
            } else {
                self?.moveToScanningState()
            }
        }
    }
    
}
