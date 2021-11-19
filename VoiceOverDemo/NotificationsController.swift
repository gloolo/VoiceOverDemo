//
//  NotificationsController.swift
//  VoiceOverDemo
//
//  Created by qiang xu on 2021/11/19.
//

import UIKit

class NotificationsController: UIViewController {

    @IBOutlet weak var button: UIButton!

    // Will Focus again on back button
    @IBAction func pushScreenWithNil(_ sender: Any) {
        toggleButtonTitle()
        UIAccessibility.post(notification: .screenChanged, argument: nil)
    }
    
    // Will Focus on last button
    @IBAction func pushScreenNotification(_ sender: Any) {
        toggleButtonTitle()
        UIAccessibility.post(notification: .screenChanged, argument: button)
    }
    
    // focus cursor won't change
    @IBAction func pushLayoutNotificationWithNil(_ sender: Any) {
        toggleButtonTitle()
        UIAccessibility.post(notification: .layoutChanged, argument: nil)
    }
    
    // focus on last button
    @IBAction func pushLayoutNotification(_ sender: Any) {
        toggleButtonTitle()
        UIAccessibility.post(notification: .layoutChanged, argument: button)
    }
    
    // read "Hello announcement" out
    @IBAction func pushAnnouncementNotification(_ sender: Any) {
        UIAccessibility.post(notification: .announcement, argument: "Hello announcement")
    }
    
    // Nothing will happen
    @IBAction func pushInGlobalQueue(_ sender: Any) {
        DispatchQueue.global().async {
            self.pushAnnouncementNotification(sender)
        }
    }
    
    // Will read the "Third" only
    @IBAction func pushMutliNotification(_ sender: Any) {
        UIAccessibility.post(notification: .announcement, argument: "First")
        UIAccessibility.post(notification: .announcement, argument: "Second")
        UIAccessibility.post(notification: .announcement, argument: "Third")
        
    }
    
    private func toggleButtonTitle() {
        let current = button.currentTitle
        button.setTitle(current == "Butter" ? "Fly" : "Butter", for: .normal)
    }
}
