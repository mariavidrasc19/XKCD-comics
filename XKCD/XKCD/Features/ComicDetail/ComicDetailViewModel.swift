//
//  ComicDetailViewModel.swift
//  XKCD
//
//  Created by Maria Vidrasc on 21.02.2025.
//

import Foundation

class ComicDetailViewModel: ObservableObject {
    var comic: Comic
    @Published var isLiked: Bool
    
    init(comic: Comic) {
        self.comic = comic
        self.isLiked = StorageService.shared.contains(comicId: comic.id)
    }
    
    func isLikeTapped() {
        if self.isLiked {
            StorageService.shared.delete(comicId: comic.id)
        } else {
            StorageService.shared.save(comic: comic)
        }
        self.isLiked.toggle()
    }
    
    func getImage(comicId: Int) -> String {
        self.isLiked ? "heart.fill" : "heart"
    }
}
