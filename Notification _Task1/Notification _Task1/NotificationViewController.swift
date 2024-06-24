//
//  NotificationViewController.swift
//  Notification _Task1
//
//  Created by Smita Kankayya on 24/06/24.
//

import UIKit

class NotificationViewController: UIViewController {
    
    @IBOutlet var firstNameLabel: UILabel!
    @IBOutlet var lastNameLabel: UILabel!
    @IBOutlet var btnClick: UIButton!
    
    
    var firstNameContainer : String?
    var lastNameContainer : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        [firstNameLabel, lastNameLabel].forEach({
            $0?.layer.borderWidth = 1;
            $0?.layer.cornerRadius = 12;
            $0?.layer.borderColor = UIColor.blue.cgColor})
        
        bindData()
    }
    
    @IBAction func btnClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func bindData(){
        self.firstNameLabel.text = firstNameContainer
        self.lastNameLabel.text = lastNameContainer
    }
}
