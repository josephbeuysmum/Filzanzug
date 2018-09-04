//
//  FZ_TableCell.swift
//  Dertisch
//
//  Created by Richard Willis on 27/07/2018.
//

import UIKit

public protocol FZTableViewCellProtocol: class, FZPopulatableViewProtocol {}

open class FZTableViewCell: UITableViewCell, FZTableViewCellProtocol {
	open func populate<T>(with data: T?) {}
}