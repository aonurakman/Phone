//
//  Integer.swift
//  Phone
//
//  Created by protel on 13.08.2020.
//  Copyright © 2020 Ahmet Onur Akman. All rights reserved.
//

import Foundation

extension Int {
    func dialPadValue() -> String {
        switch self {
        case 0...9:
            return "\(self)"
        case 10:
            return "*"
        case 11:
            return "#"
        default:
            return ""
        }
    }
}
