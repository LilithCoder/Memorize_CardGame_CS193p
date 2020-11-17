//
//  Array+Only.swift
//  Memorize
//
//  Created by William on 11/16/20.
//

import Foundation

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
