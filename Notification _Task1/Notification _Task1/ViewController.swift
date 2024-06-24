//
//  ViewController.swift
//  Notification _Task1
//
//  Created by Smita Kankayya on 24/06/24.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestNotificationPermission()
        UNUserNotificationCenter.current().delegate = self
        [firstNameTextField, lastNameTextField].forEach({
            $0?.layer.borderWidth = 1;
            $0?.layer.cornerRadius = 12;
            $0?.layer.borderColor = UIColor.blue.cgColor})
    }
    
    private func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.badge, .alert, .sound]) { granted, error in
            if let error = error {
                print("Error requesting notification authorization: \(error.localizedDescription)")
            } else {
                print("User permission is granted: \(granted)")
            }
        }
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        guard let firstName = firstNameTextField.text, !firstName.isEmpty,
              let lastName = lastNameTextField.text, !lastName.isEmpty else {
            print("First name or last name is empty.")
            return
        }
        
        let fullName = "\(firstName) \(lastName)"
        scheduleNotification(with: fullName)
        showToast(message: "Button Tapped")
        
    }
    
    private func scheduleNotification(with fullName: String) {
        let content = UNMutableNotificationContent()
        content.title = "New Notification"
        content.body = "Full Name: \(fullName)"
        content.sound = UNNotificationSound.default
        content.userInfo = ["firstName": firstNameTextField.text ?? "",
                            "lastName": lastNameTextField.text ?? ""]
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request) { error in
            if let error = error {
                print("Error adding notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully.")
            }
        }
        
    }
    
    private func showToast(message: String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width / 2 - 75, y: self.view.frame.size.height - 100, width: 150, height: 40))
        toastLabel.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }) { _ in
            toastLabel.removeFromSuperview()
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .sound, .banner])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == UNNotificationDefaultActionIdentifier {
            navigateToNotificationViewController(with: response.notification.request.content.userInfo)
        }
        completionHandler()
    }
    
    private func navigateToNotificationViewController(with userInfo: [AnyHashable: Any]) {
        if let notificationViewController = storyboard!.instantiateViewController(withIdentifier: "NotificationViewController") as? NotificationViewController {
            guard let firstName = userInfo["firstName"] as? String,
                  let lastName = userInfo["lastName"] as? String else {
                print("Error: Missing first name or last name in userInfo")
                return
            }
            
            print("First Name: \(firstName), Last Name: \(lastName)")
            
            notificationViewController.firstNameContainer = firstName
            notificationViewController.lastNameContainer = lastName
            
            navigationController!.pushViewController(notificationViewController, animated: true)
            
        }
    }
}
