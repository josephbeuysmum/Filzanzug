//
//  GeneralWaiter.swift
//  Dertisch
//
//  Created by Richard Willis on 09/10/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

class GeneralWaiterForWaiter: WaiterForWaiter {
	required init(_ waiter: Waiter, _ key: String) {
		
	}
}

//class GeneralWaiter: Waiter {
//	var carte: CarteForCustomer? { return nil }
//
//	fileprivate let maitreD: MaitreD
//
////	fileprivate var
////	customer: CustomerForWaiter?,
////	headChef: HeadChefForWaiter?
//
//	required init(maitreD: MaitreD) {
//		self.maitreD = maitreD
////		lo("BONJOUR  ", self)
//	}

//	deinit { lo("AU REVOIR", self) }
	
//	public func endShift() {
//		customer = nil
//		headChef = nil
//	}
//}

//extension GeneralWaiter: WaiterForHeadChef {
//	public func serve(entrees: FulfilledOrder) {}
//}
//
//extension GeneralWaiter: WaiterForMaitreD {
//	func introduce(_ customer: CustomerForWaiter, and headChef: HeadChefForWaiter?) {
//		self.customer = customer
//		self.headChef = headChef
//	}
//}
//
//extension GeneralWaiter: WaiterForWaiter {
//	func addToCarte(_ main: FulfilledOrder) {}
//	func fillCarte(with entrees: FulfilledOrder) {}
//}
