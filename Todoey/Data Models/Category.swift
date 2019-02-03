//
//  Category.swift
//  Todoey
//
//  Created by Ирина Дьякова on 04/01/2019.
//  Copyright © 2019 Vlad Dyakov. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
    @objc dynamic var cellColour: String = ""
}
