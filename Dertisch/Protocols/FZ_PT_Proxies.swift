//
//  FZ_PT_Proxies.swift
//  Dertisch
//
//  Created by Richard Willis on 21/03/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

import CoreData
import UIKit

// todo should these be living here?
public typealias FZCDCallback = ([NSManagedObject]?) -> Void
public typealias FZCDDeletionCallback = (Bool) -> Void
public typealias FZSignalCallback = (String, Any?) -> Void

// todo make more funcs etc "final"
// todo? maybe move protocols into their implementing classes
public protocol FZCoreDataProxyProtocol: FZModelClassProtocol {
	var dataModelName: String? { get set }
	func delete(entityName: String, _ callback: @escaping FZCDDeletionCallback)
	func delete(entityName: String, by condition: @escaping (NSManagedObject) -> Bool, _ callback: @escaping FZCDDeletionCallback)
	func retrieve(_ entityName: String, by predicate: String?, _ callback: @escaping FZCDCallback)
	func store(_ entity: FZCDEntity, _ callback: @escaping FZCDCallback)
//	func update(_ entityName: String, to key: FZCDKey, by predicate: String?, _ callback: @escaping FZCDCallback)
	func update(_ entityName: String, to attribute: FZCDAttribute, by predicate: String?, _ callback: @escaping FZCDCallback)
}

public protocol FZTemporaryValuesProxyProtocol: FZModelClassProtocol {
	func getValue(by key: String, andAnnul: Bool?) -> FZStorableDataType?
	func set(_ value: FZStorableDataType, by key: String)
	func annulValue(by key: String)
	func removeValues ()
}

public protocol FZImageProxyProtocol: FZModelClassProtocol {
	func getImage(by url: String, callback: ((String, Any?) -> Void)?) -> UIImage?
	func loadImage(by url: String)
}