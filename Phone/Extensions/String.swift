//
//  String.swift
//  Phone
//
//  Created by protel on 13.08.2020.
//  Copyright © 2020 Ahmet Onur Akman. All rights reserved.
//

import Foundation

extension String {
    func soundValue() -> Int{
        let soundDictionary: Dictionary<String,Int> = ["0":1200, "1":1201, "2":1202, "3":1203, "4":1204, "5":1205, "6":1206, "7":1207, "8":1208, "9":1209, "*": 1210, "#": 1211]
        return soundDictionary[self] ?? 0
    }
}
