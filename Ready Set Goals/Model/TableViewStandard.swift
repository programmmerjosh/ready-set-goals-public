//
//  TableViewStandard.swift
//  Ready Set Goals
//
//  Created by Joshua Van Niekerk on 02/06/2020.
//  Copyright © 2020 Josh-Dog101. All rights reserved.
//

import UIKit

class TableViewStandard {
    func setStandard(_ tblView: UITableView) {
        tblView.backgroundView = UIImageView(image: UIImage(named: "arrow-2886223_1920.jpg"))
        tblView.backgroundView?.alpha = 0.3
        tblView.backgroundView?.contentMode = .scaleAspectFill
        tblView.rowHeight = 80.0
        tblView.separatorStyle = .none
    }
}
