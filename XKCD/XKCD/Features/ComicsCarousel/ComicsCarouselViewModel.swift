//
//  ComicsCarouselViewModel.swift
//  XKCD
//
//  Created by Maria Vidrasc on 22.02.2025.
//

import Foundation

class ComicsCarouselViewModel: ObservableObject {
    @Published var errorMessage: String?
    @Published var currentID: Int? = nil // Track the current ID
    @Published var views: [ComicView] = [] // Store the views
    
    @MainActor
    func setID() {
        XKCDService.shared.fetchComics(id: nil) { result in
            switch result {
            case .success(let comic):
                self.currentID = comic.num
                self.views.append(ComicView(comicId: comic.num))
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func fetchID() {
        currentID = (currentID ?? 0) - 1
        
        // Add a new view with the updated ID
        views.append(ComicView(comicId: currentID))
    }
}

