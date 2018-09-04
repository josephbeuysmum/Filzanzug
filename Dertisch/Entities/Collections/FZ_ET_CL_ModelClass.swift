//
//  FZ_ET_CL_ModelClassEntities.swift
//  Dertisch
//
//  Created by Richard Willis on 03/08/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

//extension FZModelClassCloset: FZModelClassClosetProtocol {
//	public var bespoke: FZBespokeEntities { return bespoke_entities! }
//
//	public func bundledJson(_ key: FZKey?) -> FZBundledJsonService? {
//		return key?.teeth == key_ ? bundled_json : nil
//	}
//	
//	public func coreData(_ key: FZKey?) -> FZCoreDataProxy? {
//		return key?.teeth == key_ ? core_data : nil
//	}
//	
//	public func signals(_ key: FZKey?) -> FZSignalsService? {
//		return key?.teeth == key_ ? signals_service : nil
//	}
//	
//	public func urlSession(_ key: FZKey?) -> FZUrlSessionService? {
//		return key?.teeth == key_ ? url_session : nil
//	}
//	
//	public func deallocate() {
//		bundled_json?.deallocate()
//		bespoke_entities?.deallocate()
//		core_data?.deallocate()
//		url_session?.deallocate()
//		bespoke_entities = nil
//		core_data = nil
//		signals_service = nil
//		url_session = nil
//	}
//	
//	public func set(bundledJson: FZBundledJsonService) {
//		guard bundled_json == nil else { return }
//		bundled_json = bundledJson
//	}
//
//	public func set(coreData: FZCoreDataProxy) {
//		guard core_data == nil else { return }
//		core_data = coreData
//	}
//	
//	public func set(signalsService: FZSignalsService) {
//		guard signals_service == nil else { return }
//		signals_service = signalsService
//	}
//	
//	public func set(urlSession: FZUrlSessionService) {
//		guard url_session == nil else { return }
//		url_session = urlSession
//	}
//}
//
//public class FZModelClassCloset {
//	fileprivate let key_: String
//
//	fileprivate var
//	bundled_json: FZBundledJsonService?,
//	core_data: FZCoreDataProxy?,
//	signals_service: FZSignalsService?,
//	url_session: FZUrlSessionService?
//	
//	fileprivate lazy var bespoke_entities: FZBespokeEntities? = FZBespokeEntities()
//	
//	required public init(_ delegate: FZViperClassProtocol, key: FZKey) {
//		key_ = key.teeth
//		guaranteeSingleInstanceOfSelf(within: delegate)
//	}
//}