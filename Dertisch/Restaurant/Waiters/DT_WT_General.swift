//
//  DT_WT_Simple.swift
//  Cirk
//
//  Created by Richard Willis on 09/10/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

//import Dertisch

class GeneralWaiter: Waiter {
	var carte: CarteForCustomer? { return nil }
	
	fileprivate var
	customer: CustomerForWaiter?,
	headChef: HeadChefForWaiter?
	
	required init(customer: CustomerForWaiter, headChef: HeadChefForWaiter? = nil) {
		//lo("bonjour general waiter")
		self.customer = customer
		self.headChef = headChef
	}
	
//	deinit { lo("au revoir general waiter") }
	
	public func endShift() {
		customer = nil
		headChef = nil
	}
	
	public func startShift() {}
}

extension GeneralWaiter: WaiterForHeadChef {
	public func serve(entrees: OrderFromKitchen) {}
}

extension GeneralWaiter: WaiterForWaiter {
	func fillCarte(with entrees: OrderFromKitchen) {}
	func serve(dishes: OrderFromKitchen) {}
}
