//
//  FZ_PT_VP_ModelClass.swift
//  Dertisch
//
//  Created by Richard Willis on 11/08/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

public extension FZModelClassProtocol {
	public var instanceDescriptor: String { return String( describing: self ) }
	
	
	
	public func activate() {}
	
	public mutating func deallocate() {}
}

public protocol FZModelClassProtocol: FZViperClassProtocol {
	init(signals: FZSignalsService, modelClasses: [FZModelClassProtocol]?)
//	init()
//	var closet: FZModelClassCloset { get }
}