//
//  HealthProfileViewController.swift
//  HealthAssist
//
//  Created by Jagadeeshwar Reddy on 20/07/18.
//  Copyright © 2018 Tesco. All rights reserved.
//

import UIKit

class HealthProfileViewController: UIViewController {

    @IBOutlet weak var bgValueLabel: UILabel!
    @IBOutlet weak var bloodGlucoseBGview: UIView!
    
    @IBOutlet weak var fiberValueLabel: UILabel!
    @IBOutlet weak var carbsValueLabel: UILabel!
    @IBOutlet weak var startHoppingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        bloodGlucoseBGview.rounded()
        startHoppingButton.applyDefaultStyling()
        
        bgValueLabel.text = "\(Container.resolver.currentProfile?.bloodGlucose ?? 0)"
        title = Container.resolver.currentProfile?.name
        
        if Container.resolver.currentProfile?.isDiabetic == true {
            bloodGlucoseBGview.backgroundColor = UIColor.red
            carbsValueLabel.text = "< 16"
            fiberValueLabel.text = "> 3"
        } else {
            carbsValueLabel.text = "< 75"
            fiberValueLabel.text = "> 0"
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

extension UIView {
    func rounded() {
        layer.cornerRadius = frame.width/2.0
    }
}
