//
//  XKCDService.swift
//  XKCD
//
//  Created by Maria Vidrasc on 21.02.2025.
//

import Foundation
import SwiftUI

final class XKCDService {
    static let shared = XKCDService()
    
    func fetchComics(id: Int?) async throws -> Comic {
        let baseURL = id == nil ? "https://xkcd.com/info.0.json" : "https://xkcd.com/\(id!)/info.0.json"
        guard let url = URL(string: baseURL) else { throw URLError(.badURL) }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let comic = try JSONDecoder().decode(ServiceComic.self, from: data)
            
            guard let imageURL = URL(string: comic.img) else { throw URLError(.badURL) }
            let (imageData, _) = try await URLSession.shared.data(from: imageURL)
            
            return Comic(id: comic.num,
                         link: comic.link,
                         day: comic.day,
                         month: comic.month,
                         year: comic.year,
                         news: comic.news,
                         safeTitle: comic.safe_title,
                         transcript: comic.transcript,
                         alt: comic.alt,
                         title: comic.title,
                         imageData: imageData)
            
        } catch let error {
            throw error
        }
    }
    
    func searchComics(query: String) async throws -> [ServiceComic] {
        // Construiește URL-ul de căutare
        let searchQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://www.explainxkcd.com/wiki/index.php?search=\(searchQuery)"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        // Face cererea HTTP
        let (data, _) = try await URLSession.shared.data(from: url)
        
        // Parsează rezultatele (aici trebuie să implementezi logica de parsare)
        if let jsonString = String(data: data, encoding: .utf8) {
            print(jsonString)
        }
        let comics = try JSONDecoder().decode([ServiceComic].self, from: data)
        return comics
    }
}
