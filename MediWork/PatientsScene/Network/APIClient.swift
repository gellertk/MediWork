//
//  APIClient.swift
//  MediWork
//
//  Created by Kirill Gellert on 28.05.2023.
//

import Foundation

enum MediWorkError: Error {
    case mockFileNotFound
}

protocol APIService {
    func getPatients() async throws -> APIPatients
}

final class MockAPIClient: APIService {
        
    func getPatients() async throws -> APIPatients {
        
        guard let fileURL = Bundle.main.url(forResource: K.mockFileName, withExtension: K.mockFileExtension) else {
            throw MediWorkError.mockFileNotFound
        }

        let jsonData = try Data(contentsOf: fileURL)
        let decoder = JSONDecoder()
        let patients = try decoder.decode(APIPatients.self, from: jsonData)
        
        try await Task.sleep(nanoseconds: 2 * 1_000_000_000)
        
        return patients
    }
    
}
