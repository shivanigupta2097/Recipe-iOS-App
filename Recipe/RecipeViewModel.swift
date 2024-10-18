////
////  RecipeViewModel.swift
////  Recipe
////
////  Created by Shivani Gupta on 10/17/24.
////
//
import Foundation

@MainActor
class RecipeViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var filteredRecipes: [Recipe] = [] // New property for filtered recipes
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let recipeService: RecipeServiceProtocol

    init(recipeService: RecipeServiceProtocol = RecipeService()) {
        self.recipeService = recipeService
    }


    func fetchRecipes() async {
        isLoading = true
        do {
            let fetchedRecipes = try await recipeService.fetchRecipes()
            recipes = fetchedRecipes
            filteredRecipes = fetchedRecipes // Initially set filteredRecipes to all recipes
            errorMessage = nil
        } catch {
            errorMessage = "Failed to load recipes. Please try again later."
        }
        isLoading = false
    }

    func filterRecipes(with searchText: String) {
        // If search text is empty, show all recipes
        guard !searchText.isEmpty else {
            filteredRecipes = recipes
            return
        }

        // Filter recipes based on name or cuisine
        filteredRecipes = recipes.filter { recipe in
            recipe.name.localizedCaseInsensitiveContains(searchText) ||
            recipe.cuisine.localizedCaseInsensitiveContains(searchText)
        }
    }
}


