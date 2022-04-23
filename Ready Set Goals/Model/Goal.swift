//
//  Goal.swift
//  Ready Set Goals
//
//  Created by Joshua Van Niekerk on 20/05/2020.
//  Copyright © 2020 Josh-Dog101. All rights reserved.
//

import Foundation
import RealmSwift

class Goal: Object {
    @objc dynamic var name        : String = ""
//    @objc dynamic var checked     : Bool   = false
    @objc dynamic var dateCreated : Date?
    @objc dynamic var deadline    : Bool   = false
    @objc dynamic var deadlineDate: Date?
    @objc dynamic var progress    : Int    = 0
                  var parentCategory      = LinkingObjects(fromType: SubCategory.self, property: "goals")
}
