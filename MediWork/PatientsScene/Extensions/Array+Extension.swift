//
//  Array+Extension.swift
//  MediWork
//
//  Created by Kirill Gellert on 30.05.2023.
//

import Foundation

extension Array {

    func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>, isAscending: Bool = true) -> [Element] {
        return sorted {
            let lhs = $0[keyPath: keyPath]
            let rhs = $1[keyPath: keyPath]
            return isAscending ? lhs < rhs : lhs > rhs
        }
    }

}
