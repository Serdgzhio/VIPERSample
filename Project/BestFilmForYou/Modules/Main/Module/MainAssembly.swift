//
//  MainMainAssembly.swift
//  BestFilmForYou
//
//  Created by Azarenkov Sergey on 10/11/2020.
//  Copyright 2020 CHISW. All rights reserved.
//


import Swinject
import SwiftUI

final class MainAssembly: Assembly {
  func assemble(container: Container) {
    container.register(MainModule.self) { (resolver) -> MainModule in
      guard let remoteRepository = resolver.resolve(FilmRepository.self, arguments: Environment.mock, RepositoryLocation.remote)
      else { preconditionFailure() }
      let interactor = MainInteractor(repository: remoteRepository)
      let router = MainRouter(locator: ApplicationLocator.shared)
      let presenter = MainPresenter(routerInput: router, interactorInput: interactor)
      let viewModel = MainViewModel(output: presenter)
      presenter.viewInput = viewModel
      interactor.output = presenter
      router.output = presenter
      let view = MainView().environmentObject(viewModel)
      let viewController = UIHostingController(rootView: view)
      router.origin = viewController
      viewModel.bindState()
      let module = MainModule(view: viewController, inputListener: presenter)
      return module
    }
  }
}
