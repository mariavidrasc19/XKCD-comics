//
//  ServiceComic.swift
//  XKCD
//
//  Created by Maria Vidrasc on 25.02.2025.
//

import Foundation

struct ServiceComic: Codable {
    var num: Int
    var link: String
    var day: String
    var month: String
    var year: String
    var news: String
    var safe_title: String
    var transcript: String
    var alt: String
    var img: String
    var title: String
}
