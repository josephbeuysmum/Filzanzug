//
//  DT_PT_UT_Interactor.swift
//  Dertisch
//
//  Created by Richard Willis on 22/06/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

//import Foundation

public protocol HeadChefForSousChef {
	mutating func give(prep: InternalOrder)
}

public protocol HeadChefForWaiter: GiveOrderProtocol {}

public protocol HeadChef: HeadChefForWaiter, HeadChefForSousChef, KitchenResource, StaffMember, SwitchesRelationshipProtocol {
	init(_ resources: [String: KitchenResource]?)
	var waiter: WaiterForHeadChef? { get set }
}

public extension HeadChef {
	public func beginBreak() {}
	public func beginShift() {}
	public func endBreak() {}
	public func endShift() {}
	public func give(_ order: OrderFromCustomer) {}
}

public extension HeadChefForSousChef {
	public func give(prep: InternalOrder) {
		let fulfilledOrder: FulfilledOrder
		if let dishes = prep.dishes as? Dishionarizer {
			fulfilledOrder = FulfilledOrder(prep.ticket, dishes: dishes)
		} else {
			fulfilledOrder = FulfilledOrder(prep.ticket)
		}
		Rota().waiterForHeadChef(self as? SwitchesRelationshipProtocol)?.serve(main: fulfilledOrder)
	}
}
