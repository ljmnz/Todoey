//
//  Item.swift
//  Todoey
//
//  Created by Luke McCarthy on 13/02/19.
//  Copyright © 2019 Luke McCarthy. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
