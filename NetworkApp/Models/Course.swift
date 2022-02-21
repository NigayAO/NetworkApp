//
//  Course.swift
//  NetworkApp
//
//  Created by Alik Nigay on 17.02.2022.
//

import Foundation
import UIKit

struct Course: Codable {
    let id: Int?
    let name: String?
    let link: String?
    let imageUrl: String?
    let numberOfLessons: Int?
    let numberOfTests: Int?
    
    init(value: [String: Any]) {
        id = value["id"] as? Int
        name = value["name"] as? String
        link = value["link"] as? String
        imageUrl = value["imageUrl"] as? String
        numberOfLessons = value["numberOfLessons"] as? Int
        numberOfTests = value["numberOfTests"] as? Int
    }
}


struct WebSiteDescription: Codable {
    let courses: [Course]
    let websiteDescription: String?
    let websiteName: String?
    
    init(value: [String: Any]) {
        let coursesDict = value["courses"] as? [String: Any] ?? [:]
        courses = [Course(value: coursesDict)]
        websiteDescription = value["websiteDescription"] as? String
        websiteName = value["websiteName"] as? String
    }
}

struct ImageProperties {
    let key: String
    let image: Data
    
    init?(withImage image: UIImage, forKey key: String) {
        self.key = key
        guard let data = image.pngData() else { return nil }
        self.image = data
    }
}
