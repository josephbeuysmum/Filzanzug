//
//  FZ_PT_UT_Interactor.swift
//  Filzanzug
//
//  Created by Richard Willis on 22/06/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

import Foundation

public extension FZInteractorProtocol {
	public var instanceDescriptor: String { return String(describing: self) }
	
	public var closet: FZInteractorCloset? {
		return FirstInstance().get(FZInteractorCloset.self, from: mirror_)
	}
	
	private var key_: FZKey? {
		return FirstInstance().get(FZKey.self, from: mirror_)
	}
	
	private var mirror_: Mirror { return Mirror(reflecting: self) }
	
	
	
	public func activate() {
		guard
			let key = key_,
			let safeCloset = closet,
			let presenterClassName = safeCloset.presenter(key)?.instanceDescriptor,
			let signals = closet?.signals(key)
			else { return }
		_ = signals.scanFor(signal: FZSignalConsts.presenterActivated, scanner: self) { _, data in
			guard
				let safeSelf = self as FZInteractorProtocol?,
				let presenter = data as? FZPresenterProtocol,
				presenter.instanceDescriptor == presenterClassName
				else { return }
			var mutatingSelf = safeSelf
			mutatingSelf.presenterActivated()
		}
		// todo why is this not simply in the closure immediately above?
		_ = Timer.scheduledTimer(withTimeInterval: TimeInterval(1), repeats: false) { timer in
			_ = signals.stopScanningFor(signal: FZSignalConsts.presenterActivated, scanner: self)
			timer.invalidate()
		}
	}
}

public protocol FZInteractorProtocol: FZViperClassProtocol {
	var closet: FZInteractorCloset? { get }
	mutating func presenterActivated ()
}
