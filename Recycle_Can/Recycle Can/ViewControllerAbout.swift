//
//  ViewControllerAbout.swift
//  Recycle Can
//
//  Created by - on 2017/06/13.
//  Copyright © 2017 Recycle Canada. All rights reserved.
//
import UIKit
import MessageUI
import Foundation
import Social

class ViewControllerAbout: UIViewController, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var logoImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height

        
        if (screenHeight <= 480) {
            print(screenHeight)
            print(screenWidth)

            print("Success!")
            logoImage.alpha = 0
        } else {
            print("Not an iPhone 4s... or this does not work :(")
        }
    }
    @IBAction func RateBtn(_ sender: Any) {
        
        let alert = UIAlertController(title: "Rate This App", message:  "This will open up the App Store", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Go", style: UIAlertActionStyle.default)  { _ in
            // Open App in AppStore
            let iLink = "https://itunes.apple.com/us/app/recycle-can/id1248915926?ls=1&mt=8"
            UIApplication.shared.openURL(NSURL(string: iLink)! as URL)
        } )
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    @IBAction func WebBtn(_ sender: Any) {
        let iLink = "http://www.recyclecan.ca"
        UIApplication.shared.openURL(NSURL(string: iLink)! as URL)
        
    }
    @IBAction func FacebookBtn(_ sender: Any) {
        
        // Check if Facebook is available
        if (SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook))
        {
            // Create the post
            let post = SLComposeViewController(forServiceType: (SLServiceTypeFacebook))
            post?.setInitialText("\n\nhttps://itunes.apple.com/us/app/recycle-can/id1248915926?ls=1&mt=8")
            post?.add(UIImage(named: "Screenshot_5"))
            self.present(post!, animated: true, completion: nil)
        } else {
            // Facebook not available. Show a warning
            let alert = UIAlertController(title: "Facebook", message: "Facebook not available", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func MailBtn(_ sender: Any) {
        // Check if Mail is available
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
//        mailComposerVC.setToRecipients(["someone@somewhere.com"])
        mailComposerVC.setSubject("Check Out This Recycling App!")
        mailComposerVC.setMessageBody("\n\n\nhttps://itunes.apple.com/us/app/recycle-can/id1248915926?ls=1&mt=8", isHTML: false)
        let imageData = UIImagePNGRepresentation(UIImage(named: "Screenshot_5")!)
        mailComposerVC.addAttachmentData(imageData!, mimeType: "image/png", fileName: "Image")
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    


}
