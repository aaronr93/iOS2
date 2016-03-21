//
//  PocketGrover.swift
//  Pocket Grovers
//
//  Created by Aaron Rosenberger on 3/21/16.
//  Copyright © 2016 Nafberger Games. All rights reserved.
//

import Foundation

enum State {
    case Burned
    case Frozen
    case Paralyzed
    case Poisoned
    case Sleeping
    case Confused
}

class PocketGrover {
    var name: String?
    var actions = [String]()
    var state: State?
}