//
//  DT_ET_FirstInstanceGetter.swift
//  Dertisch
//
//  Created by Richard Willis on 17/07/2018.
//

struct FirstInstance {
	func get<T>(_ from: T.Type, from mirror: Mirror) -> T? {
		for (_, child) in mirror.children.enumerated() {
			if let t = child.value as? T {
				return t
			}
		}
		return nil
	}
}
