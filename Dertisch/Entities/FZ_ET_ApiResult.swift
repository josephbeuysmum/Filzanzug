//
//  FZ_ET_ApiResult.swift
//  Dertisch
//
//  Created by Richard Willis on 08/09/2016.
//  Copyright © 2016 Rich Text Format Ltd. All rights reserved.
//

import Foundation

public struct FZApiResult: FZDescribableProtocol {
	public var description: String {
		return "<FZApiResult success: \( String( describing:  success ) ) url: \( String( describing: url ) ) hasData: \( data != nil ) >"
	}
	public let
	success: Bool?,
	url: String?,
	data: Any?
}