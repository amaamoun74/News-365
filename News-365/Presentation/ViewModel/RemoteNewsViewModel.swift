//
//  RemoteNewsViewModel.swift
//  News-365
//
//  Created by ahmed on 24/08/2023.
//

import Foundation
import Combine

class RemoteNewsViewModel{
    private let remoteUseCase = RemoteUseCase()
    @Published var news: News = News()
    @Published var errorMessage: String = ""
    private var cancellables: Set<AnyCancellable> = []
    
    func getNews(category: String, complition: @escaping(Result<News? , NetworkError>) -> Void){
        let country = UserDefaults.standard.value(forKey: Constants.shared.COUNTRYCODE) as? String ?? "EG"
        remoteUseCase.getNews(category: category, country: country) { result in
            complition(result)
        }
    }
    func searchForNews(titleKeyword: String , complition: @escaping(Result<News? , NetworkError>) -> Void){
        remoteUseCase.searchNews(keyword: titleKeyword) { result in
            complition(result)
        }
    }
    
    func fetchNews(category: String) {
        let country = UserDefaults.standard.value(forKey: Constants.shared.COUNTRYCODE) as? String ?? "EG"
        remoteUseCase.getNews(category: category, country: country)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .failure(let error):
                        print("error in combine")
                        self?.handleError(error)
                    case .finished:
                        print("finished")
                        break
                    }
                }, receiveValue: { [weak self] newsRsponse in
                    guard newsRsponse.articles != nil else {
                        self?.handleError(.customError(NSLocalizedString("errorMSG", comment: "")))
                        return
                    }
                    self?.news = newsRsponse
                })
                .store(in: &cancellables)
        }
        
    private func handleError(_ error: NetworkError) {
        switch (error) {
        case .networkFailure:
            errorMessage = NSLocalizedString("networkFailure", comment: "")
            print("No internet connection")
            
        case .clientError(statusCode: let statusCode):
            errorMessage = NSLocalizedString("ClinetError", comment: "")
            print("Bad request with status code \(statusCode) .. please try agian")
            
        case .serverError(statusCode: let statusCode):
            errorMessage = NSLocalizedString("serverError", comment: "")
            print("Server error with status code \(statusCode).. please try again later")
            
        case .invalidResponse:
            errorMessage = NSLocalizedString("invalidResponse", comment: "")
            print("Bad response")
            
        case .decodingError:
            errorMessage = NSLocalizedString("decodingError", comment: "")
            print("Error while getting response from the server")
            
        case .encodingError:
            errorMessage = NSLocalizedString("encodingError", comment: "")
            print("Error while sending requset to server")
            
        case .customError(let errotMSG):
            errorMessage = errotMSG
            print("defualt error")
        }
    }
            
}
