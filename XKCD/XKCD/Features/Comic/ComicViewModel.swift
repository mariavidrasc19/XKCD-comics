//
//  ComicViewModel.swift
//  XKCD
//
//  Created by Maria Vidrasc on 21.02.2025.
//

import Foundation

class ComicViewModel: ObservableObject {
    var comic: Comic
    @Published var isLiked: Bool
    
    // save favorites
    private let storageService: StorageServiceProtocol = StorageService()
    
    init(comic: Comic) {
        self.comic = comic
        self.isLiked = storageService.contains(comicId: comic.num)
    }

    func isLikeTapped() {
        if isLiked {
            storageService.delete(comicId: comic.num)
        } else {
            storageService.save(comic: comic)
        }
        isLiked.toggle()
    }
}
