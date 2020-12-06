//
//  LibraryLibraryAssembly.swift
//  BestFilmForYou
//
//  Created by Azarenkov Sergey on 21/10/2020.
//  Copyright 2020 CHISW. All rights reserved.
//


import Swinject

class LibraryAssembly: Assembly {
    func assemble(container: Container) {
        container.register(LibraryModule.self) { (resolver) -> LibraryModule in
            let interactor = LibraryInteractor()
            let viewController = LibraryViewController.fromStoryboard()
            let router = LibraryRouter()
            router.resolver = resolver as? Resolvable
            router.origin = viewController
            let presenter = LibraryPresenter(viewInput: viewController, interactorInput: interactor, routerInput: router)
            interactor.output = presenter
            viewController.output = presenter
            let module = LibraryModule(view: viewController, input: presenter)
            return module
        }

    }
}

