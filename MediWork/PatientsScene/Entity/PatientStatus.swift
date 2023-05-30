//
//  PatientStatus.swift
//  MediWork
//
//  Created by Kirill Gellert on 28.05.2023.
//

import Foundation

enum PatientStatus: String {
    case preplacementInProgress = "PreplacementInProgress"
    case readyForPreplacement = "ReadyForPreplacement"
    
    var statusDescription: String {
        switch self {
        case .preplacementInProgress:
            return "Preplacement in Progress"
        case .readyForPreplacement:
            return "Ready for Preplacement"
        }
    }
}
