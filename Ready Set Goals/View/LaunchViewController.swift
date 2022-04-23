//
//  LaunchViewController.swift
//  Ready Set Goals
//
//  Created by Joshua Van Niekerk on 02/06/2020.
//  Copyright © 2020 Josh-Dog101. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.async{
            super.viewDidLoad()
            
            self.perform(#selector(self.showNavController), with: nil, afterDelay: 2)
        }
    }
    
    @objc func showNavController() {
        performSegue(withIdentifier: "toNavController", sender: self)
    }
}
