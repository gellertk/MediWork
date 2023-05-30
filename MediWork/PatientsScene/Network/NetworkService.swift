//
//  NetworkService.swift
//  MediWork
//
//  Created by Kirill Gellert on 28.05.2023.
//

import Foundation

protocol NetworkService {
    func getPatients() async throws -> APIPatients
}

final class NetworkManager: NetworkService {
    
    private let apiClient: APIService
    
    init(apiClient: APIService) {
        self.apiClient = apiClient
    }
    
    func getPatients() async throws -> APIPatients {
        return try await self.apiClient.getPatients()
    }
    
}
