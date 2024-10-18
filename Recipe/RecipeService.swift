//
//  RecipeService.swift
//  Recipe
//
//  Created by Shivani Gupta on 10/17/24.
//

import Foundation

protocol RecipeServiceProtocol {
    func fetchRecipes() async throws -> [Recipe]
}


// Wrapper struct to match the JSON response structure
struct RecipeResponse: Codable {
    let recipes: [Recipe]
}

class RecipeService: RecipeServiceProtocol {
    private let endpoint = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!

    func fetchRecipes() async throws -> [Recipe] {
        do {
            let (data, response) = try await URLSession.shared.data(from: endpoint)
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw URLError(.badServerResponse)
            }

            let decodedResponse = try JSONDecoder().decode(RecipeResponse.self, from: data)
            return decodedResponse.recipes
        } catch let error as DecodingError {
            print("Decoding error: \(error)")
            throw error
        } catch {
            print("Unexpected error: \(error)")
            throw error
        }
    }
}

//class RecipeService: RecipeServiceProtocol {
//    private let endpoint = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!
//
//    func fetchRecipes() async throws -> [Recipe] {
//        do {
//            let (data, response) = try await URLSession.shared.data(from: endpoint)
//            
//            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
//                throw URLError(.badServerResponse)
//            }
//
//            let decodedResponse = try JSONDecoder().decode(RecipeResponse.self, from: data)
//            return decodedResponse.recipes
//        } catch let error as DecodingError {
//            print("Decoding error: \(error)")
//            throw error
//        } catch {
//            print("Unexpected error: \(error)")
//            throw error
//        }
//    }
//}
