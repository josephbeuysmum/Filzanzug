//
//  FZ_PX_Image.swift
//  Filzanzug
//
//  Created by Richard Willis on 25/11/2015.
//  Copyright © 2015 Richard Willis. All rights reserved.
//

import UIKit

extension FZImageProxy: FZImageProxyProtocol {
	public var wornCloset: FZWornCloset? { return worn_closet }
	
	
	
	public func activate () {}
	
	public func getImage ( by url: String, callback:( ( String, Any? ) -> Void )? = nil ) -> UIImage? {
		let image = getLocalImage( by: url )
		guard image == nil else { return image }
		guard
			callback != nil,
			let scopedSignals = worn_closet.getSignals( by: key_ring.key )
			else { return nil }
		let urlKey = getUrlKey( by: url )
		scopedSignals.scanOnceFor( signal: urlKey, scanner: self ) { [weak self] _, data in
			guard let safeSelf = self, safeSelf.assess( result: data ) else { return }
			callback!( url, safeSelf.getLocalImage( by: url ) )
		}
		loadImage( by: url )
		return nil
	}
	
	public func loadImage ( by url: String ) {
		guard
			let scopedUrlSession = worn_closet.getModelClassEntities( by: key_ring.key )?.urlSession,
			let scopedSignals = worn_closet.getSignals( by: key_ring.key )
			else { return }
		_ = scopedSignals.scanOnceFor( signal: url, scanner: self ) { [weak self] _, data in
			guard let safeSelf = self else { return }
			if let urlIndex = safeSelf.urlsResolving.index( of: url ) { safeSelf.urlsResolving.remove( at: urlIndex ) }
			guard safeSelf.assess( result: data ) else { return }
			let result = data as! FZApiResult
			safeSelf.raw_images[ url ] = result.data as? Data
			scopedSignals.transmit(signal: safeSelf.getUrlKey( by: url ), with: url )
		}
		scopedUrlSession.call( url: url, method: FZUrlSessionService.methods.GET )
	}
	
	
	
	fileprivate func assess ( result: Any? ) -> Bool {
		guard
			let result = result as? FZApiResult,
			let success = result.success,
			success,
			result.data is Data
			else { return false }
		return true
	}
	
	fileprivate func getLocalImage ( by url: String ) -> UIImage? {
		return raw_images[ url ] != nil ? UIImage( data: raw_images[ url ]! ) : nil
	}
	
	fileprivate func getUrlKey ( by url: String ) -> String { return "\( key_ring.key )_\( url )" }
}

public class FZImageProxy {
	fileprivate let
	key_ring: FZKeyring,
	worn_closet: FZWornCloset


	fileprivate var
	urlsResolving: [ String ],
	raw_images: Dictionary< String, Data >

	required public init(with keyring: FZKeyring) {
		key_ring = keyring
		worn_closet = FZWornCloset(key_ring.key)
		urlsResolving = []
		raw_images = [:]
	}
	
	deinit {}
}
