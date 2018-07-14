//
//  FZ_PT_UT_Interactor.swift
//  Filzanzug
//
//  Created by Richard Willis on 22/06/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

import Foundation

public extension FZInteractorProtocol {
	public var instanceDescriptor: String { return String( describing: self ) }
	
	// todo this is repeated code, here and in FZPresenterProtocol, is there any way to avoid repeating it?
	public var entities: FZInteractorEntities? {
		let selfReflection = Mirror( reflecting: self )
		var ents: FZInteractorEntities?
		for (_, child) in selfReflection.children.enumerated() {
			if child.value is FZInteractorEntities {
				if ents != nil { fatalError("FZInteractors can only possess one FZWornCloset") }
				ents = (child.value as? FZInteractorEntities)
			}
		}
		return ents
	}
	fileprivate var key_: String? {
		let selfReflection = Mirror( reflecting: self )
		for (_, child) in selfReflection.children.enumerated() {
			if child.value is FZKeyring {
				return (child.value as? FZKeyring)?.key
			}
		}
		return nil
	}

	
	
	public func activate () {
		lo("CURRENTLY DISABLED")
//		guard
//			let scopedKey = key_,
//			let presenterClassName = wornCloset?.getInteractorEntities(by: scopedKey)?.presenter.instanceDescriptor,
//			let signals = wornCloset?.getSignals( by: scopedKey )
//			else { return }
//		_ = signals.scanFor(signal: FZSignalConsts.presenterActivated, scanner: self ) { _, data in
//			guard
//				let presenter = data as? FZPresenterProtocol,
//				presenter.instanceDescriptor == presenterClassName
//				else { return }
////			signals.transmitSignalFor( key: FZSignalConsts.interactorActivated, data: self )
//			self.postPresenterActivated()
//		}
//		_ = Timer.scheduledTimer( withTimeInterval: TimeInterval( 1.0 ), repeats: false ) { timer in
//			_ = self.wornCloset?.getSignals(by: scopedKey)?.stopScanningFor(signal: FZSignalConsts.presenterActivated, scanner: self)
//			timer.invalidate() }
	}
	
	// implemented just in case they are not required in their given implementer, so that a functionless function need not be added
//	public func deallocate () { wornCloset?.deallocate() }
	public func postPresenterActivated () {}
}

public protocol FZInteractorProtocol: FZViperTemporaryNameProtocol {
	var entities: FZInteractorEntities? { get }
	func postPresenterActivated ()
}
