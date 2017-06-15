//
//  ViewControllerAbout.swift
//  Recycle Can
//
//  Created by - on 2017/06/13.
//  Copyright © 2017 Recycle Canada. All rights reserved.
//
import UIKit

import Foundation

class ViewControllerAbout: UIViewController {
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


}
