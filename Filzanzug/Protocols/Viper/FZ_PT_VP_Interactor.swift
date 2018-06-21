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
	public var wornCloset: FZWornCloset? {
		let selfReflection = Mirror( reflecting: self )
		var wc: FZWornCloset?
		for (_, child) in selfReflection.children.enumerated() {
			if child.value is FZWornCloset {
				if wc != nil { fatalError("FZInteractors can only possess one FZWornCloset") }
				wc = (child.value as? FZWornCloset)
			}
		}
		return wc
	}
	fileprivate var closet_key: String? {
		let selfReflection = Mirror( reflecting: self )
		var key: String?
		for ( _, child ) in selfReflection.children.enumerated() {
			if child.value is FZKeyring {
				if key != nil { fatalError("FZInteractors can only possess one FZKeyring") }
				key = (child.value as? FZKeyring)?.key
			}
		}
		return key
	}

	
	
	public func activate () {
		guard
			let scopedKey = closet_key,
			let presenterClassName = wornCloset?.getInteractorEntities(by: scopedKey)?.presenter.instanceDescriptor,
			let scopedSignals = wornCloset?.getSignals( by: scopedKey )
			else { return }
		_ = scopedSignals.scanFor(signal: FZSignalConsts.presenterActivated, scanner: self ) { _, data in
			guard
				let presenter = data as? FZPresenterProtocol,
				presenter.instanceDescriptor == presenterClassName
				else { return }
//			scopedSignals.transmitSignalFor( key: FZSignalConsts.interactorActivated, data: self )
			self.postPresenterActivated()
		}
		_ = Timer.scheduledTimer( withTimeInterval: TimeInterval( 1.0 ), repeats: false ) { timer in
			_ = self.wornCloset?.getSignals(by: scopedKey)?.stopScanningFor(signal: FZSignalConsts.presenterActivated, scanner: self)
			timer.invalidate() }
	}
	
	// implemented just in case they are not required in their given implementer, so that a functionless function need not be added
	public func deallocate () { wornCloset?.deallocate() }
	public func postPresenterActivated () {}
}

public protocol FZInteractorProtocol: FZWornClosetImplementerProtocol {
//	var presenter: FZPresenterProtocol? { get }
//	func createWornCloset () -> FZWornCloset?
	func postPresenterActivated ()
}
