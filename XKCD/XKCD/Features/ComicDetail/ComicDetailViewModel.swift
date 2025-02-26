//
//  ComicDetailViewModel.swift
//  XKCD
//
//  Created by Maria Vidrasc on 21.02.2025.
//

import Foundation

class ComicDetailViewModel: ObservableObject {
    var comic: Comic
    
    init(comic: Comic) {
        self.comic = comic
    }

    func isLikeTapped() {
        if StorageService.shared.contains(comicId: comic.id) {
            StorageService.shared.delete(comicId: comic.id)
        } else {
            StorageService.shared.save(comic: comic)
        }
    }
    
    func getImage(comicId: Int) -> String {
        StorageService.shared.contains(comicId: comicId) ? "heart.fill" : "heart"
    }
}
