//
//  Patient.swift
//  MediWork
//
//  Created by Kirill Gellert on 28.05.2023.
//

import Foundation

struct Patient: Hashable {
  
    let id: String
    let firstName: String
    let lastName: String
    let company: String
    let createdAt: Date?
    let status: PatientStatus?
    let phone: String
    let mobilePhone: String?
    let email: String?
    
    var properties: [PatientProperty] {
        let properties = Mirror(reflecting: self)
        return properties.children.compactMap { property -> PatientProperty? in
            guard let label = property.label else { return nil }
            guard let rowProperty = RowProperty(rawValue: label) else { return nil }
            guard rowProperty.isRow else { return nil }
            guard let properyValue = property.value as? String else { return nil }
            let properyLabel = rowProperty.rawValue
            return .init(label: properyLabel, value: properyValue)
        }
    }
    
    var mobilePhoneString: String {
        return self.mobilePhone ?? ""
    }
    
    var emailString: String {
        return self.email ?? ""
    }
    
    var createdAtString: String {
        return K.dateFormatter.string(from: self.createdAt ?? Date())
    }
    
    var statusString: String {
        return self.status?.rawValue ?? ""
    }
    
    init(apiPatient: APIPatient) {
        self.id = apiPatient.id
        self.firstName = apiPatient.firstName
        self.lastName = apiPatient.lastName
        self.createdAt = K.dateFormatter.date(from: apiPatient.created) 
        self.status = .init(rawValue: apiPatient.fullStatus.statusEnum)
        self.phone = apiPatient.fixedLinePhone
        self.mobilePhone = apiPatient.mobilePhone
        self.email = apiPatient.email
        self.company = apiPatient.clientOrganisation.name
    }
    
}
