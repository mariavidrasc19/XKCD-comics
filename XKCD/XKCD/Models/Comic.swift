//
//  Comic.swift
//  XKCD
//
//  Created by Maria Vidrasc on 21.02.2025.
//

import Foundation
import UIKit

struct Comic: Codable {
    var id: Int
    var link: String
    var day: String
    var month: String
    var year: String
    var news: String
    var safeTitle: String
    var transcript: String
    var alt: String
    var title: String
    
    // keeping Data to manage encodation
    var imageData: Data?

    // get UIImage from Data
    var image: UIImage? {
        if let imageData = imageData {
            return UIImage(data: imageData)
        }
        return nil
    }
    
    var isFavorite: Bool
    
    init(id: Int,
         link: String,
         day: String,
         month: String,
         year: String,
         news: String,
         safeTitle: String,
         transcript: String,
         alt: String,
         title: String,
         imageData: Data?) {
            self.month = month
            self.id = id
            self.link = link
            self.year = year
            self.news = news
            self.safeTitle = safeTitle
            self.transcript = transcript
            self.alt = alt
            self.title = title
            self.day = day
            self.imageData = imageData
            self.isFavorite = StorageService.shared.contains(comicId: id)
        }
}
