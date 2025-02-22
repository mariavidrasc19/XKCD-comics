//
//  XKCDService.swift
//  XKCD
//
//  Created by Maria Vidrasc on 21.02.2025.
//

import Foundation

final class XKCDService {
    static let shared = XKCDService()
    
    func fetchComics(id: Int?, completion: @escaping (Result<Comic, Error>) -> Void) {
        let baseURL = id == nil ? "https://xkcd.com/info.0.json" : "https://xkcd.com/\(id!)/info.0.json"
        guard let url = URL(string: baseURL) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            do {
                let comic = try JSONDecoder().decode(Comic.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(comic))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
