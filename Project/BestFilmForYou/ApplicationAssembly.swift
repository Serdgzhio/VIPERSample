//
//  ApplicationAssembly.swift
//  BestFilmForYou
//
//  Created by user on 27.11.2020.
//  Copyright © 2020 CHI software. All rights reserved.
//

import Swinject

class ApplicationAssembly: Assembly {
  func assemble(container: Container) {
    container.register(RemoteDataSource.self, factory: { (_, env: Environment) -> RemoteDataSource in
      switch env {
      case .mock:
        return MockRemoteDataSource()
      }
    }).inObjectScope(.container)
    
    container.register(FilmRepository.self) { (resolver, env: Environment, location: RepositoryLocation) -> FilmRepository in
      switch location {
      case .remote:
        guard let dataSource = resolver.resolve(RemoteDataSource.self, argument: env) else {
          preconditionFailure()
        }
        return FilmRemoteRepository(dataSource: dataSource)
      }
    }
  }
}
