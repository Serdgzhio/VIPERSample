//
//  ImageWrapper.swift
//  BestFilmForYou
//
//  Created by user on 22.10.2020.
//  Copyright © 2020 CHI software. All rights reserved.
//

import UIKit

struct ImageWrapper {
    var image: UIImage?
    init(with name:String) {
        image = UIImage(named: name)
    }
}
