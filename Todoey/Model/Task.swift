//
//  Task.swift
//  Todoey
//
//  Created by Merouane Bellaha on 13/06/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct Task: Codable {
    var taskName: String
    var taskIsDone = false

    init(taskName: String) {
        self.taskName = taskName
    }
}
