//
//  SubCategory.swift
//  Ready Set Goals
//
//  Created by Joshua Van Niekerk on 20/05/2020.
//  Copyright © 2020 Josh-Dog101. All rights reserved.
//

import Foundation
import RealmSwift

class SubCategory: Object {
    @objc dynamic var name       : String = ""
                  var parentCategory      = LinkingObjects(fromType: Category.self, property: "subCategories")
                  let goals               = List<Goal>()
}
