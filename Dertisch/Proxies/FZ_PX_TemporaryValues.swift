//
//  FZ_PX_LocalAccess.swift
//  Dertisch
//
//  Created by Richard Willis on 11/02/2016.
//  Copyright © 2016 Rich Text Format Ltd. All rights reserved.
//

import UIKit

extension FZTemporaryValuesProxy: FZTemporaryValuesProxyProtocol {
//	public var closet: FZModelClassCloset { return closet_ }
	
	
	
	public func activate() { is_activated = true }
	
	public func getValue(by key: String, andAnnul: Bool? = false) -> FZStorableDataType? {
		guard let value = values_[key] else { return nil }
		if andAnnul! { annulValue(by: key) }
		return value
	}
	
	// todo use FZStorableDataType protocol (or something damned similar) to make value more flexible than just String
	public func set(_ value: FZStorableDataType, by key: String) {
		values_[key] = value
		signals_.transmit(signal: FZSignalConsts.valueSet, with: key)
	}
	
	public func annulValue(by key: String) {
		guard values_[key] != nil else { return }
		values_.removeValue(forKey: key)
	}
	
	public func removeValues() {
//		guard let signals = closet_.signals(key_) else { return }
		for (key, _) in values_ { _ = annulValue(by: key) }
		signals_.transmit(signal: FZSignalConsts.valuesRemoved )
	}
	
//	public func deleteValue ( by key: String ) {
//		storage.removeObject( forKey: key )
//	}
//	
//	//	public func deleteValues ( key: String ) {}
//	
//	public func retrieveValue ( by key: String ) -> String? {
//		return storage.string( forKey: key )
//	}
//	
//	// store ("set") the given property
//	public func store ( value: String, by key: String, and caller: FZCaller? = nil ) {
//		guard let signals = wornCloset.getSignals( by: key_.teeth ) else { return }
//		let signalKey = FZSignalConsts.valueStored
//		FZMisc.set( signals: signals, withKey: signalKey, andCaller: caller )
//		storage.setValue( value, forKey: key )
//		storage.synchronize()
//		signals.transmitSignalFor( key: signalKey )
//	}

}

public class FZTemporaryValuesProxy {
	fileprivate let signals_: FZSignalsService
	
	fileprivate var
	is_activated: Bool,
	values_: Dictionary<String, FZStorableDataType>
//	key_: FZKey!,
//	closet_: FZModelClassCloset!

	required public init(signals: FZSignalsService, modelClasses: [FZModelClassProtocol]?) {
		signals_ = signals
		is_activated = false
		values_ = [:]
//		key_ = FZKey(self)
//		closet_ = FZModelClassCloset(self, key: key_)
	}
	
	deinit {}
}