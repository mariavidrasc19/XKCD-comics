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
    
    func searchComics(query: String) async throws -> [Comic] {
        // Construiește URL-ul de căutare
        let searchQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://www.explainxkcd.com/wiki/index.php?action=parse&search=\(searchQuery)"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        // Face cererea HTTP
        let (data, _) = try await URLSession.shared.data(from: url)
        
        // Parsează rezultatele HTML
        let comics = try parseSearchResults(from: data)
        return comics
    }
    
    private func parseSearchResults(from data: Data) throws -> [Comic] {
        var comics: [Comic] = []
        
        // Transformă datele în String
        guard let htmlString = String(data: data, encoding: .utf8) else {
            throw URLError(.cannotDecodeContentData)
        }
        do {
           let html = "<html><head><title>First parse</title></head>"
               + "<body><p>Parsed HTML into a doc.</p></body></html>"
           let doc: Document = try SwiftSoup.parse(html)
            print(try doc.text())
        } catch Exception.Error(_, let message) {
            print(message)
        } catch {
            print("error")
        }
        
        // Parsează HTML-ul folosind SwiftSoup
        let document = try SwiftSoup.parse(htmlString)
        
        // Extrage toate link-urile din rezultatele căutării
        let searchResults = try document.select("div.mw-search-results li")
        
        for result in searchResults {
            // Extrage titlul și link-ul
            let titleElement = try result.select("a").first()
            let title = try titleElement?.text() ?? ""
            let link = try titleElement?.attr("href") ?? ""
            // Extrage ID-ul comic-ului din link (dacă este posibil)
            if let comicID = extractComicID(from: link) {
                // Creează un obiect Comic
                let comic = Comic(
                    num: comicID,
                    link: "https://www.explainxkcd.com\(link)",
                    day: "",
                    month: "",
                    year: "",
                    news: title,
                    safeTitle: "",
                    transcript: "",
                    alt: "",
                    title: title,
                    imageData: nil
                )
                comics.append(comic)
            }
        }
        return comics
    }

    private func extractComicID(from link: String) -> Int? {
        // Extrage ID-ul comic-ului din link (de exemplu, "/wiki/index.php/1234")
        let pattern = "/wiki/index.php/(\\d+)"
        let regex = try? NSRegularExpression(pattern: pattern)
        if let match = regex?.firstMatch(in: link, range: NSRange(link.startIndex..., in: link)),
           let range = Range(match.range(at: 1), in: link) {
            return Int(link[range])
        }
        return nil
    }
}
