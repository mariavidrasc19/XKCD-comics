//
//  ComicsCarouselViewModel.swift
//  XKCD
//
//  Created by Maria Vidrasc on 22.02.2025.
//

import Foundation

class ComicsScrollViewModel: ObservableObject {
    @Published var errorMessage: String?
    // Track the current ID that we use for adding new comics in the list
    @Published var currentID: Int? = nil
    // Store the comics
    @Published var comics: [Comic] = []
    
    // save favorites
    let storageService: StorageServiceProtocol = StorageService()
    
    @MainActor
    func setID() {
        fetchComic(by: nil)
    }
    
    @MainActor 
    func fetchID() {
        currentID = (currentID ?? 0) - 1
        
        // Add a new view with the updated ID
        fetchComic(by: currentID)
    }

    @MainActor
    private func fetchComic(by id: Int?) {
        XKCDService.shared.fetchComics(id: id) { result in
            switch result {
            case .success(let comic):
                if self.currentID == nil {
                    self.currentID = comic.num
                }
                self.comics.append(comic)
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func getImage(for comicId: Int) -> String {
        storageService.contains(comicId: comicId) ? "heart.fill" : "heart"
    }
}

