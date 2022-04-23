//
//  Category.swift
//  Ready Set Goals
//
//  Created by Joshua Van Niekerk on 20/05/2020.
//  Copyright © 2020 Josh-Dog101. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name         :String             = ""
                  var subCategories                    = List<SubCategory>()
}
