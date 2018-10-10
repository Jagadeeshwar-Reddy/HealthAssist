//
//  ProfilesViewController.swift
//  HealthAssist
//
//  Created by Jagadeeshwar Reddy on 12/07/18.
//  Copyright © 2018 Tesco. All rights reserved.
//

import UIKit
import JSONUtilities

class ProfilesViewController: UIViewController {
    
    @IBOutlet var profileViews: [UIView]!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        profileViews.forEach { view in
            view.layer.borderColor = UIColor(white: 229 / 255.0, alpha: 1.0).cgColor
            view.layer.borderWidth = 1.0
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func profile1Tapped(_ sender: Any) {
        Container.resolver.currentProfile = try? CustomerHealthProfile(jsonDictionary: jsonFromProfileFile(name: "Tom"))
        performSegue(withIdentifier: "details", sender: self)
    }
    
    @IBAction func profile2Tapped(_ sender: Any) {
        Container.resolver.currentProfile = try? CustomerHealthProfile(jsonDictionary: jsonFromProfileFile(name: "Gerico"))
        performSegue(withIdentifier: "details", sender: self)
    }
   
    @IBAction func profile3Tapped(_ sender: Any) {
        Container.resolver.currentProfile = try? CustomerHealthProfile(jsonDictionary: jsonFromProfileFile(name: "Alexa"))
        performSegue(withIdentifier: "details", sender: self)
    }
    
    
    private func jsonFromProfileFile(name: String) -> JSONDictionary {
        let bundle = Bundle(for: type(of: self))
        guard let file = bundle.path(forResource: name, ofType: "profile"), let string = try? String(contentsOfFile: file) else {
            return JSONDictionary()
        }
        let json = try? JSONSerialization.jsonObject(with: Data(string.utf8), options: .allowFragments) as? JSONDictionary ?? JSONDictionary()
        return json!
    }
    
}

