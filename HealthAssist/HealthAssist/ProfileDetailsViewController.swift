//
//  ProfileDetailsViewController.swift
//  HealthAssist
//
//  Created by Jagadeeshwar Reddy on 13/07/18.
//  Copyright © 2018 Tesco. All rights reserved.
//

import UIKit

final class ProfileDetailsViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        self.title = Container.resolver.currentProfile?.name
        view.backgroundColor = UIColor(white: 246 / 255.0, alpha: 1.0)
        tableview.backgroundColor = UIColor(white: 246 / 255.0, alpha: 1.0)
        tableview.tableFooterView = UIView()
        nextButton.applyDefaultStyling()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }       
}

extension ProfileDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "Cell")
        guard let profile = Container.resolver.currentProfile else { return cell }
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Name"
            cell.detailTextLabel?.text = profile.name
        case 1:
            cell.textLabel?.text = "Age"
            cell.detailTextLabel?.text = "\(profile.age)"
        case 2:
            cell.textLabel?.text = "Sex"
            cell.detailTextLabel?.text = profile.biologicalSex.rawValue
        case 3:
            cell.textLabel?.text = "BMI"
            cell.detailTextLabel?.text = "\(profile.bodyMassIndex)"
        case 4:
            cell.textLabel?.text = "Height"
            cell.detailTextLabel?.text = "\(profile.height)"
        case 5:
            cell.textLabel?.text = "BodyMass"
            cell.detailTextLabel?.text = "\(profile.bodyMass)"
        case 6:
            cell.textLabel?.text = "ActiveEnergy"
            cell.detailTextLabel?.text = "\(profile.activeEnergy)"
        case 7:
            cell.textLabel?.text = "BodyFatPercentage"
            cell.detailTextLabel?.text = "\(profile.bodyFatPercentage)"
        case 8:
            cell.textLabel?.text = "OxygenSaturation"
            cell.detailTextLabel?.text = "\(profile.oxygenSaturation)"
        case 9:
            cell.textLabel?.text = "BloodGlucose"
            cell.detailTextLabel?.text = "\(profile.bloodGlucose) mg/dL"
        default:
            return cell
        }
        return cell
    }
}
