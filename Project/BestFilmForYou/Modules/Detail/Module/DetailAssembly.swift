//
//  DetailDetailAssembly.swift
//  BestFilmForYou
//
//  Created by Azarenkov Sergey on 04/12/2020.
//  Copyright 2020 CHISW. All rights reserved.
//


import Swinject

final class DetailAssembly: Assembly {
  func assemble(container: Container) {
    container.register(DetailModule.self) { (resolver) -> DetailModule in
      guard let remoteRepository = resolver.resolve(FilmRepository.self, arguments: Environment.mock, RepositoryLocation.remote) else { preconditionFailure() }
      let interactor = DetailInteractor(repository: remoteRepository)
      let router = DetailRouter()
      let presenter = DetailPresenter(routerInput: router, interactorInput: interactor)
      let viewController = DetailViewController.construct(output: presenter)
      interactor.output = presenter
      presenter.viewInput = viewController
      router.origin = viewController
      router.output = presenter
      let module = DetailModule(view: viewController, inputListener: presenter)
      return module
    }
    
  }
}
