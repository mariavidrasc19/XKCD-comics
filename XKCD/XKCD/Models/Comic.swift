//
//  Comic.swift
//  XKCD
//
//  Created by Maria Vidrasc on 21.02.2025.
//

import Foundation
import UIKit

struct Comic: Codable {
    var num: Int
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
    
    init(num: Int,
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
            self.num = num
            self.link = link
            self.year = year
            self.news = news
            self.safeTitle = safeTitle
            self.transcript = transcript
            self.alt = alt
            self.title = title
            self.day = day
            self.imageData = imageData
        }
    
//    init(from serviceComic: ServiceComic) throws {
//        let (imageData, _) = try await URLSession.shared.data(from: serviceComic.img)
//        self.init(num: serviceComic.num,
//                  link: serviceComic.link,
//                  day: serviceComic.day,
//                  month: serviceComic.month,
//                  year: serviceComic.year,
//                  news: serviceComic.news,
//                  safeTitle: serviceComic.safe_title,
//                  transcript: serviceComic.transcript,
//                  alt: serviceComic.alt,
//                  title: serviceComic.title,
//                  imageData: imageData)
//    }
}
