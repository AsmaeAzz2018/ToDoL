//
//  Category.swift
//  ToDoL
//
//  Created by mac on 1/12/20.
//  Copyright © 2020 mac. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
   @objc dynamic var name : String = ""
    var items = List<Item>()
}
