//
//  ApplicationLocator.swift
//  BestFilmForYou
//
//  Created by user on 26.11.2020.
//  Copyright © 2020 CHI software. All rights reserved.
//

import Swinject

class ApplicationLocator {
  var assembler = Assembler()
  static let shared = ApplicationLocator()
  private init() {}
  
  var assemblies: [Assembly] {
    [
      MainAssembly(),
      DetailAssembly(),
      ResultAssembly(),
      ApplicationAssembly()
    ]
  }
  
  lazy var mainScreen: MainModule = {
    assembler.apply(assemblies: assemblies)
    return getMainModule()
  }()
  
  private func getMainModule() -> MainModule {
    guard let mainModule = assembler.resolver.resolve(MainModule.self) else { preconditionFailure("Failed to init MainModule")
    }
    return mainModule
  }
}
