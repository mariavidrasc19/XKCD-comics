//
//  ComicCellViewModel.swift
//  XKCD
//
//  Created by Maria Vidrasc on 26.02.2025.
//

import Foundation

class ComicCellViewModel: ObservableObject {
    var comic: Comic
    @Published var isLiked: Bool
    
    // save favorites
    private let storageService: StorageServiceProtocol = StorageService()
    
    init(comic: Comic) {
        self.comic = comic
        self.isLiked = storageService.contains(comicId: comic.id)
    }
    
    func isLikeTapped() {
        if isLiked {
            storageService.delete(comicId: comic.id)
        } else {
            storageService.save(comic: comic)
        }
        isLiked.toggle()
    }
}
