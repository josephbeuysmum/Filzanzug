//
//  DT_SV_Routing.swift
//  Dertisch
//
//  Created by Richard Willis on 12/11/2016.
//  Copyright © 2016 Rich Text Format Ltd. All rights reserved.
//
// todo "All rights reserved" needs changing to MIT licence somehow

import UIKit



public protocol DTMaitreDExtension {
	func registerStaff(with key: String)
}

public protocol DTMaitreDRegistrar {
	func register(
		_ modelClassType: DTKitchenMember.Type,
		with key: String,
		injecting dependencyTypes: [DTKitchenMember.Type]?)
	func introduce(
		_ customerId: String,
		as customerType: DTCustomerProtocol.Type,
		with key: String,
		waiter waiterType: DTWaiter.Type?,
		chef headChefType: DTHeadChef.Type?,
		kitchenStaff kitchenStaffTypes: [DTKitchenMember.Type]?)
}

public protocol DTMaitreDProtocol: DTMaitreDRegistrar {
	var hasMenu: Bool { get }
	func alert(actions: [UIAlertAction], title: String?, message: String?, style: UIAlertController.Style?)
	func closeRestaurant()
	func createNibFrom(name nibName: String, for owner: DTCustomer) -> UIView?
//	func create(_ customerId: String, from storyboard: String?) -> DTCustomer?
//	func createAlertWith(
//		title: String,
//		message: String,
//		buttonLabel: String,
//		handler: @escaping ((UIAlertAction) -> Void),
//		plusExtraButtonLabel extraButtonLabel: String?) -> UIAlertController
	func greet(firstCustomer customerId: String, through window: UIWindow, from storyboard: String?)
	func present(menu menuId: String, inside rect: CGRect?, from storyboard: String?)
	func removeMenu(_ closure: DTBasicClosure?)
	func seatNext(_ customerId: String, via transitionStyle: UIModalTransitionStyle?, from storyboard: String?)
	func usherOutCurrentCustomer()
}



fileprivate typealias DTCustomerTicket = (customer: DTCustomer, id: String)

public class DTMaitreD {
	fileprivate let
	key: String,
	sommelier: DTSommelier
	
	fileprivate var
	kitchenStaff: Dictionary<String, DTKitchenMember>,
	switchesRelationships: Dictionary<String, DTInternalSwitchRelationship>,
	window: UIWindow!,
	formerCustomers: [DTCustomerTicket],
//	rootSwitches: DTSwitchesRelationship?,
	currentSwitches: DTSwitchesRelationship?,
	menuSwitches: DTSwitchesRelationship?
	
	required public init() {
		key = NSUUID().uuidString
		kitchenStaff = [:]
		switchesRelationships = [:]
		formerCustomers = []
		let bundledJson = DTBundledJson()
		kitchenStaff[DTBundledJson.staticId] = bundledJson
		sommelier = DTSommelier(bundledJson: bundledJson)
	}
}



extension DTMaitreD: DTMaitreDProtocol {
	public var hasMenu: Bool {
		return menuSwitches != nil
	}
	
	public func alert(
		actions: [UIAlertAction],
		title: String? = nil,
		message: String? = nil,
		style: UIAlertController.Style? = .alert) {
		guard let customer = currentSwitches?.customer else { return }
		let
		alert = UIAlertController(title: title, message: message, preferredStyle: style!),
		countActions = actions.count
		for i in 0..<countActions {
			alert.addAction(actions[i])
		}
		customer.present(alert, animated: true)
	}
	
	public func createNibFrom(name nibName: String, for owner: DTCustomer) -> UIView? {
		guard let viewArray = Bundle.main.loadNibNamed(nibName, owner: owner, options: nil) else { return nil }
		return viewArray[0] as? UIView
	}
	
//	public func create(_ customerId: String, from storyboard: String? = nil) -> DTCustomer? {
//		return createBundleFrom(customerId, and: storyboard)?.customer
//	}
	
//	public func createAlertWith(
//		title: String,
//		message: String,
//		buttonLabel: String,
//		handler: @escaping((UIAlertAction) -> Void),
//		plusExtraButtonLabel extraButtonLabel: String? = nil) -> UIAlertController {
//		let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
//		// copy
//		alert.addAction(UIAlertAction(title: buttonLabel, style: UIAlertActionStyle.default, handler: handler))
//		if extraButtonLabel != nil {
//			alert.addAction(UIAlertAction(title: extraButtonLabel!, style: UIAlertActionStyle.default, handler: nil))
//		}
//		return alert
//	}
	
	
	public func closeRestaurant() {
		currentSwitches?.endShift()
		menuSwitches?.endShift()
//		exit(1)
	}
	
	public func greet(firstCustomer customerId: String, through window: UIWindow, from storyboard: String? = nil) {
		// todo should this be a fatal error?
		guard self.window == nil else { return }
		registerStaff(with: key)
		// todo some sort of feedback for silent returns?
		guard
			let rootSwitches = createBundle(from: customerId, and: storyboard),
			let rootCustomer = rootSwitches.customer
			else { return }
		DTTime.startInterval()
		self.window = window
		self.window.makeKeyAndVisible()
		self.window.rootViewController = rootCustomer
		currentSwitches = rootSwitches
		formerCustomers.append((rootCustomer, customerId))
	}
	
	public func introduce(
		_ customerId: String,
		as customerType: DTCustomerProtocol.Type,
		with key: String,
		waiter waiterType: DTWaiter.Type? = nil,
		chef headChefType: DTHeadChef.Type? = nil,
		kitchenStaff kitchenStaffTypes: [DTKitchenMember.Type]? = nil) {
		guard
			switchesRelationships[customerId] == nil,
			key == self.key
			else { return }
		switchesRelationships[customerId] = DTInternalSwitchRelationship(
			customerType: customerType,
			waiterType: waiterType,
			headChefType: headChefType,
			kitchenStaffTypes: kitchenStaffTypes)
	}
	
	public func present(
		menu menuId: String,
		inside rect: CGRect? = nil,
		from storyboard: String? = nil) {
		guard
			!hasMenu,
			let currentCustomer = currentSwitches?.customer,
			let switchBundle = createBundle(from: menuId, and: storyboard),
			let menu = switchBundle.customer
			else { return }
		menu.modalPresentationStyle = .popover
		currentCustomer.present(menu, animated: true) {
//			self.orders_.make(order: DTOrdercountCirclespopoverAdded)
		}
		menu.popoverPresentationController?.sourceView = currentCustomer.view
		if let safeRect = rect {
			menu.popoverPresentationController?.sourceRect = safeRect
		}
		menuSwitches = switchBundle
	}
	
	public func register(
		_ kitchenStaffType: DTKitchenMember.Type,
		with key: String,
		injecting dependencyTypes: [DTKitchenMember.Type]? = nil) {
		guard key == self.key else { return }
		let kitchenClasses = getKitchenStaff(from: dependencyTypes)
		let kitchenStaffMember = kitchenStaffType.init(kitchenClasses)
		self.kitchenStaff[kitchenStaffType.staticId] = kitchenStaffMember
		kitchenStaffMember.startShift()
	}
	
	public func removeMenu(_ closure: DTBasicClosure? = nil) {
		guard hasMenu else { return }
		menuSwitches!.customer?.dismiss(animated: true) { [unowned self] in
			closure?()
			self.menuSwitches!.endShift()
			self.menuSwitches = nil
		}
	}
	
	// todo will we reinstate something like this in future?
//	public func seat(
//		_ customerId: String,
//		via transitionType: CATransitionType? = nil,
//		and transitionSubtype: CATransitionSubtype? = nil,
//		from storyboard: String? = nil) {
//		guard
//			let switchBundle = createBundle(from: customerId, and: storyboard),
//			let customer = switchBundle.customer
//			else { return }
//		if let transitionType = transitionType {
//			let transition = CATransition()
//			transition.duration = 0.25
//			transition.timingFunction = CAMediaTimingFunction.init(name: .easeInEaseOut)
//			transition.type = transitionType
//			transition.subtype = transitionSubtype ?? .fromRight
//			window.layer.add(transition, forKey: nil)
//		}
//		window.rootViewController = customer
//		currentSwitches?.endShift()
//		currentSwitches = switchBundle
//	}
	
	public func seatNext(
		_ customerId: String,
		via transitionStyle: UIModalTransitionStyle? = nil,
		from storyboard: String? = nil) {
		guard
			let currentCustomer = currentSwitches?.customer,
			var switchBundle = createBundle(from: customerId, and: storyboard),
			let nextCustomer = switchBundle.customer
			else { return }
		let animated = transitionStyle != nil
//		, currentCustomerIsRoot = currentCustomer === window.rootViewController
//		lo(currentCustomerIsRoot)
		if animated {
			nextCustomer.modalTransitionStyle = transitionStyle!
		}
		currentCustomer.present(nextCustomer, animated: animated) { //[unowned self] in
			lo("presented: \(nextCustomer)")
		}
		currentSwitches?.endShift()
		switchBundle.animated = animated
		currentSwitches = switchBundle
	}
	
	public func usherOutCurrentCustomer() {
		guard currentSwitches != nil else { return }
		currentSwitches!.customer?.dismiss(animated: currentSwitches!.animated) { [unowned self] in
			self.currentSwitches!.endShift()
			guard let formerCustomer = self.formerCustomers.popLast() else { return }
			self.currentSwitches = self.createBundle(from: formerCustomer)
		}
	}
	
	
	
	
	
	fileprivate func createBundle(from ticket: DTCustomerTicket) -> DTSwitchesRelationship? {
		guard let switchesRelationship = switchesRelationships[ticket.id] else { return nil }
		let kitchenStaff = getKitchenStaff(from: switchesRelationship.kitchenStaffTypes)
		var headChef = switchesRelationship.headChefType != nil ? switchesRelationship.headChefType!.init(kitchenStaff) : nil
		let waiter = switchesRelationship.waiterType != nil ?
			switchesRelationship.waiterType!.init(customer: ticket.customer,  headChef: headChef) :
			GeneralWaiter(customer: ticket.customer, headChef: headChef)
		headChef?.waiter = waiter
		ticket.customer.assign(waiter, maitreD: self, and: sommelier)
		waiter.startShift()
		headChef?.startShift()
		return DTSwitchesRelationship(customer: ticket.customer, waiter: waiter, headChef: headChef, animated: false)
	}
	
	fileprivate func createBundle(from customerId: String, and storyboard: String? = nil) -> DTSwitchesRelationship? {
		guard
			switchesRelationships[customerId] != nil,
			let customer = UIStoryboard(
				name: storyboard ?? "Main",
				bundle: nil).instantiateViewController(withIdentifier: customerId) as? DTCustomer
			else { return nil }
		return createBundle(from: (customer: customer, id: customerId))
	}
	
	fileprivate func getKitchenStaff(from dependencyTypes: [DTKitchenMember.Type]?) -> [String: DTKitchenMember]? {
		guard dependencyTypes?.count ?? -1 > 0 else { return nil }
		var kitchenStaff: [String: DTKitchenMember] = [:]
		for dependencyType in dependencyTypes! {
			let dependencyId = dependencyType.staticId
			if let dependencyClass = self.kitchenStaff[dependencyId] {
				kitchenStaff[dependencyId] = dependencyClass
			}
		}
		return kitchenStaff
	}
}
