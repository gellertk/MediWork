//
//  Patients.swift
//  MediWork
//
//  Created by Kirill Gellert on 28.05.2023.
//

import Foundation

struct APIPatients: Decodable {
    let count: Int
    let data: [APIPatient]
}

struct APIPatient: Decodable {
    let id: String
    let personnelNumber: String?
    let title, firstName: String
    let middleName: String?
    let lastName: String
    let dateOfBirth: String?
    let email: String?
    let secondaryEmail: String?
    let fixedLinePhone: String
    let mobilePhone: String?
    let addressLine1: String?
    let addressLine2: String?
    let addressLine3: String?
    let addressLine4: String?
    let addressLine5: String?
    let city: String?
    let postalCode: String?
    let region: String?
    let country: String?
    let ineligibleForNationalInsuranceNumber: Bool
    let nationalInsuranceNumber: String?
    let roleTitle: String
    let engagementType: String
    let uniqueId: String
    let created: String
    let createdBy: String
    let modified: String
    let modifiedBy: String
    let startDate, endDate: String?
    let genderAtBirth: String?
    let genderIdentifiedWith: String?
    let genderPronoun: String
    let lineManagerEmail: String?
    let isActive: Bool
    let status: String
    let fullStatus: APIFullStatus
    let clientOrganisation: APIClientOrganisation
}
