//
//  Data.swift
//  Todoey
//
//  Created by Harshit Ruwali on 19/04/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object{
    @objc dynamic var name: String = ""
    @objc dynamic var age:Int = 0
    
}
