//
//  Item.swift
//  ToDoL
//
//  Created by mac on 1/12/20.
//  Copyright © 2020 mac. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
 @objc dynamic var title : String = ""
 @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
 var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
