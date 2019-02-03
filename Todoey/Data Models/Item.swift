//
//  Item.swift
//  Todoey
//
//  Created by Ирина Дьякова on 04/01/2019.
//  Copyright © 2019 Vlad Dyakov. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var isDone: Bool = false
    @objc dynamic var date: Date = Date()
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
