//
//  MockRecipeService.swift
//  Recipe
//
//  Created by Shivani Gupta on 10/17/24.
//
import Foundation

class MockRecipeService: RecipeServiceProtocol {
    let endpoint: URL

    init(endpoint: URL) {
        self.endpoint = endpoint
    }

    func fetchRecipes() async throws -> [Recipe] {
        let (data, response) = try await URLSession.shared.data(from: endpoint)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(RecipeResponse.self, from: data).recipes
    }
}


