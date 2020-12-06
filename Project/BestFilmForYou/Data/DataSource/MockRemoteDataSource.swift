//
//  MockRemoteDataSource.swift
//  BestFilmForYou
//
//  Created by user on 26.11.2020.
//  Copyright © 2020 CHI software. All rights reserved.
//

import Foundation
class MockRemoteDataSource: RemoteDataSource {
  func execute<T: RemoteRequest>(request: T, completion: @escaping (Result<T.ResultType, Error>) -> Void) {
    let result = Bundle.main.decode(T.ResultType.self, from: "\(request.description).json")
    completion(.success(result))
  }
}
