//
//  Factory.swift
//  MediWork
//
//  Created by Kirill Gellert on 28.05.2023.
//

import Foundation

final class Factory {
    
    func makePatientsViewController() -> PatientsViewController {
        let apiClient: APIService = MockAPIClient()
        let networkService: NetworkService = NetworkManager(apiClient: apiClient)
        let viewModel: PatientsViewModel = .init(networkService: networkService)
        let viewController: PatientsViewController = .init(viewModel: viewModel)
        return viewController
    }
    
}
