//
//  ViewState.swift
//  MediWork
//
//  Created by Kirill Gellert on 30.05.2023.
//

import Foundation

enum ViewState: Equatable {
    case loading
    case error(String)
    case done
}
