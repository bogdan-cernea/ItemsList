//
//  List.swift
//  ItemsList
//
//  Created by bogdan.cernea on 07/05/2020.
//  Copyright © 2020 bogdan.cernea. All rights reserved.
//

import Foundation

struct List: Decodable {
    let title: String
    let items: [Item]
    
    enum CodingKeys: String, CodingKey {
        case title
        case items = "rows"
    }
}
