//
//  APIFullStatus.swift
//  MediWork
//
//  Created by Kirill Gellert on 28.05.2023.
//

import Foundation

struct APIFullStatus: Decodable {
    let statusLabel: String
    let statusCode: String
    let statusEnum: String
}
