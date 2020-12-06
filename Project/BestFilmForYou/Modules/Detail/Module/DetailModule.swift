//
//  DetailDetailModule.swift
//  BestFilmForYou
//
//  Created by Azarenkov Sergey on 04/12/2020.
//  Copyright 2020 CHISW. All rights reserved.
//


import Foundation

final class DetailModule : Modulable {
    typealias InputListener = DetailModuleInput
	let view: Origin
	var transition: Transition?
	var inputListener: InputListener

	init(view: Origin, inputListener: InputListener){
    	self.view = view
	    self.inputListener = inputListener
	}
}
