//
//  Item.swift
//  Todoey
//
//  Created by Ирина Дьякова on 09/12/2018.
//  Copyright © 2018 Vlad Dyakov. All rights reserved.
//

import Foundation

class Item: Codable {
    var title = ""
    var isDone = false
    
    init(_ name: String) {
        title = name
    }
    
}
