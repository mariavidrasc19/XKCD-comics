//
//  XKCDSearchService.swift
//  XKCD
//
//  Created by Maria Vidrasc on 25.02.2025.
//

import Foundation
import SwiftSoup

final class XKCDSearchService {
    static let shared = XKCDSearchService()
    
    func searchComics(query: String) async throws -> [Int] {
        // Search url
        let searchQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://www.explainxkcd.com/wiki/index.php?action=parse&search=\(searchQuery)"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        // pars result to HTML
        let comics = try parseSearchResults(from: data)
        return comics
    }
    
    private func parseSearchResults(from data: Data) throws -> [Int] {
        // transform data into string
        guard let htmlString = String(data: data, encoding: .utf8) else {
            throw URLError(.cannotDecodeContentData)
        }
        
        // Parse HTML using SwiftSoup
//        let safeHtml = try SwiftSoup.clean(htmlString, Whitelist.basic())!
        let document = try SwiftSoup.parse(htmlString)
        
        // extract the elements with a tag that contain the ids of result comics
        let searchResults = try document.select("ul.mw-search-results li")        
        var comicIds: [Int] = []
        
        for result in searchResults {
            // extract the link that contains comic id
            let titleElement = try result.select("a").first()
            guard let link = try titleElement?.attr("href") else { continue}
            
            // extract the ID of the comic from the link ("/wiki/index.php/1003:...")
            let pattern = "/wiki/index.php/(\\d+)"
            let regex = try? NSRegularExpression(pattern: pattern)
            
            if let match = regex?.firstMatch(in: link, range: NSRange(link.startIndex..., in: link)),
               let range = Range(match.range(at: 1), in: link),
               let comicId = Int(link[range]) {
                comicIds.append(comicId)
            }
        }
        
        return comicIds
    }
}
