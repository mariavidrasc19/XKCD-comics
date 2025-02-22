//
//  ComicViewModel.swift
//  XKCD
//
//  Created by Maria Vidrasc on 21.02.2025.
//

import Foundation

class ComicViewModel: ObservableObject {
    @Published var comic: Comic? = nil
    var comicId: Int? = nil
    @Published var isLoading: Bool = true
    @Published var errorMessage: String?
    
    @MainActor
    func loadData() {
        XKCDService.shared.fetchComics(id: comicId) { result in
            self.isLoading = false
            switch result {
            case .success(let comic):
                self.comic = comic
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
