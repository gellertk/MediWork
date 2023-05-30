//
//  PatientsViewModel.swift
//  MediWork
//
//  Created by Kirill Gellert on 28.05.2023.
//

import Combine
import UIKit

final class PatientsViewModel {
    
    // MARK: - Variables
    
    private let networkService: NetworkService
    private let queue: DispatchQueue = .init(label: "com.MediWork.PatientsViewModel")
    
    private var bag: Set<AnyCancellable> = .init()
    
    internal let onShouldLoadData: PassthroughSubject<Void, Never> = .init()
    
    @Published internal var viewState: ViewState = .loading
    @Published internal var patients: [Patient] = []
    
    // MARK: - Lifecycle
    
    init(networkService: NetworkService) {
        self.networkService = networkService
        self.configureSubscriptions()
    }
    
    private func configureSubscriptions() {
        
        self.onShouldLoadData
            .receive(on: self.queue)
            .sink { [weak self] in
                guard let self else { return }
                self.getPatients()
            }
            .store(in: &bag)
        
    }
    
    private func getPatients() {
        Task {
            do {
                let apiPatients = try await self.networkService.getPatients()
                self.patients = apiPatients.data.map ({ .init(apiPatient: $0) })
                self.viewState = .done
            } catch {
                self.viewState = .error(error.localizedDescription)
            }
        }
    }
    
}
