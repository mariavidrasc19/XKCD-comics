//
//  StorageService.swift
//  XKCD
//
//  Created by Maria Vidrasc on 23.02.2025.
//

import Foundation

protocol StorageServiceProtocol {
    func save(comic: Comic)
    func getComics() -> [Comic]
    func contains(comicId: Int) -> Bool
    func delete(comicId: Int)
}

final class StorageService: StorageServiceProtocol {
    private let userDefaultsComicsKey = "favoriteComics"
    
    func save(comic: Comic) {
        var comicsList = getComics()
        comicsList.append(comic)
        if let encodedData = try? JSONEncoder().encode(comicsList) {
            UserDefaults.standard.set(encodedData, forKey: userDefaultsComicsKey)
        }
    }
    
    func getComics() -> [Comic] {
        if let savedData = UserDefaults.standard.data(forKey: userDefaultsComicsKey),
           let comicsList = try? JSONDecoder().decode([Comic].self, from: savedData) {
            return comicsList
        }
        return []
    }
    
    func contains(comicId: Int) -> Bool {
        let comicsList = getComics()
        if comicsList.contains(where: { comic in comic.num == comicId}) {
            return true
        }
        return false
    }
    
    func delete(comicId: Int) {
        let newComicsList = getComics().filter({ comic in comic.num != comicId})
        if let encodedData = try? JSONEncoder().encode(newComicsList) {
                UserDefaults.standard.set(encodedData, forKey: userDefaultsComicsKey)
        }
    }
}
