//
//  RemoteDataSource.swift
//  BestFilmForYou
//
//  Created by user on 26.11.2020.
//  Copyright © 2020 CHI software. All rights reserved.
//

import Foundation

protocol RemoteDataSource {
  func execute<T: RemoteRequest>(request: T, completion: @escaping (Result<T.ResultType, Error>) -> Void)
}
enum RepositoryLocation: String {
  case remote
}
enum Environment: String {
  case mock
}
