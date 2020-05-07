//
//  Item.swift
//  ItemsList
//
//  Created by bogdan.cernea on 07/05/2020.
//  Copyright © 2020 bogdan.cernea. All rights reserved.
//

import Foundation

struct Item: Decodable {
    let title: String?
    let description: String?
    let imageHref: String?
}
