//
//  RouterProtocols.swift
//  BestFilmForYou
//
//  Created by user on 13.10.2020.
//  Copyright © 2020 CHI software. All rights reserved.
//
import Swinject

protocol Routable {
    var origin: Origin? { get set }
}
