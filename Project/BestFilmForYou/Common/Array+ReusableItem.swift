//
//  Array+ReusableItem.swift
//  BestFilmForYou
//
//  Created by user on 13.10.2020.
//  Copyright © 2020 CHI software. All rights reserved.
//

import Foundation

extension Array {
    func merge(with array: [ReusableItem]) -> [ReusableItem] {
        return self.compactMap({ element -> ReusableItem? in
            guard
                let element = element as? ReusableItem,
                !array.contains(where: { $0.reuseIdentifier == element.reuseIdentifier} )
                else { return nil }
            return element
        })
    }
}
