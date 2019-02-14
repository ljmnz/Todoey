//
//  Category.swift
//  Todoey
//
//  Created by Luke McCarthy on 13/02/19.
//  Copyright © 2019 Luke McCarthy. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    let items = List<Item>()
    
}
