//
//  ComicDetailViewModel.swift
//  XKCD
//
//  Created by Maria Vidrasc on 21.02.2025.
//

import Foundation
import UIKit

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
        return StorageService.shared.contains(comicId: comic.id) ? "heart.fill" : "heart"
    }
    
    func openBrowser() {
        if let url = URL(string: "https://www.explainxkcd.com/wiki/index.php/\(comic.id)") {
            UIApplication.shared.open(url)
        }
    }
}
