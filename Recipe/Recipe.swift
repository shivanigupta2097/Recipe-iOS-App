//
//  Recipe.swift
//  Recipe
//
//  Created by Shivani Gupta on 10/17/24.
//
import Foundation

struct Recipe: Identifiable, Codable {
    let id: UUID
    let name: String
    let cuisine: String
    let photoUrlLarge: String
    let photoUrlSmall: String
    let sourceUrl: String?
    let youtubeUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case name
        case cuisine
        case photoUrlLarge = "photo_url_large"
        case photoUrlSmall = "photo_url_small"
        case sourceUrl = "source_url"
        case youtubeUrl = "youtube_url"
    }
}
