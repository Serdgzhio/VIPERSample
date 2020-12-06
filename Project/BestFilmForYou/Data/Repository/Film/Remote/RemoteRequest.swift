//
//  NetworkRequest.swift
//  BestFilmForYou
//
//  Created by user on 14.10.2020.
//  Copyright © 2020 CHI software. All rights reserved.
//

import Foundation

protocol RemoteRequest: CustomStringConvertible{
  associatedtype ResultType: Decodable
}
