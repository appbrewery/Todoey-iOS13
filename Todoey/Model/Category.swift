//
//  Category.swift
//  Todoey
//
//  Created by Seth Thorup on 2/4/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    var items = List<Item>()
}
