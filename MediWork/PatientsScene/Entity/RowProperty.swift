//
//  RowProperty.swift
//  MediWork
//
//  Created by Kirill Gellert on 30.05.2023.
//

import Foundation

enum RowProperty: String, CaseIterable {
    
    case firstName
    case lastName
    case id
    case createdAt
    case company
    case statusString
    case phone
    case mobilePhone
    case email

    var label: String {
        switch self {
        case .id:
            return "ID"
        case .createdAt:
            return "Created Date"
        case .company:
            return "Company"
        case .statusString:
            return "Status"
        case .phone:
            return "Phone"
        case .mobilePhone:
            return "Mobile"
        case .email:
            return "Email"
        case .firstName:
            return "First Name"
        case .lastName:
            return "Last name"
        }
    }
    
    var keyPath: KeyPath<Patient, String> {
        switch self {
        case .id:
            return \.id
        case .createdAt:
            return \.createdAtString
        case .company:
            return \.company
        case .phone:
            return \.phone
        case .statusString:
            return \.statusString
        case .mobilePhone:
            return \.mobilePhoneString
        case .email:
            return \.emailString
        case .firstName:
            return \.firstName
        case .lastName:
            return \.lastName
        }
    }
    
    var isRow: Bool {
        switch self {
        case .firstName:
            return false
        case .lastName:
            return false
        case .id:
            return true
        case .createdAt:
            return true
        case .company:
            return true
        case .statusString:
            return true
        case .phone:
            return true
        case .mobilePhone:
            return true
        case .email:
            return true
        }
    }
    
}
