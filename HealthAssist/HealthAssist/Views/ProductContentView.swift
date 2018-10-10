//
//  ProductContentView.swift
//  HealthAssist
//
//  Created by Jagadeeshwar Reddy on 12/07/18.
//  Copyright © 2018 Tesco. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import TriLabelView

class ProductContentView: UIView {

    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var colorCodeView: TriLabelView! {
        didSet {
            colorCodeView.viewColor = UIColor.white
            colorCodeView.labelText = ""
        }
    }
    
    func configure(with product: Product) {
        if let imageURL = product.thumbnailURL {
            imageview.af_setImage(withURL: imageURL)
        }
        titleLabel.text = product.title
        
        guard let profile = Container.resolver.currentProfile else { return }
        colorCodeView.viewColor = product.healthCode(for: profile).colorCode
    }
}

extension UIColor {
    class var green: UIColor {
        return UIColor(red:0.29, green:0.66, blue:0.26, alpha:1.0)
    }
    
    class var red: UIColor {
        return UIColor(red:0.99, green:0.36, blue:0.39, alpha:1.0)
    }
    
    class var amber: UIColor {
        return UIColor(red:1.00, green:0.85, blue:0.00, alpha:1.0)
    }
}
