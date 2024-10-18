//
//  RecipeTests.swift
//  RecipeTests
//
//  Created by Shivani Gupta on 10/17/24.
//


import XCTest
@testable import Recipe

class RecipeServiceTests: XCTestCase {
    var service: RecipeService!

    override func setUp() {
        super.setUp()
        service = RecipeService()
    }

    func testFetchRecipesSuccess() async throws {
        let recipes = try await service.fetchRecipes()
        XCTAssertFalse(recipes.isEmpty, "Recipes should not be empty when the fetch is successful")
    }



    func testFetchRecipesDecodingError() async {
        // Mock service with a malformed JSON endpoint
        let mockService = MockRecipeService(endpoint: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json")!)

        do {
            _ = try await mockService.fetchRecipes()
            XCTFail("Expected to throw a decoding error, but it succeeded.")
        } catch is DecodingError {
            // Decoding error caught as expected
            XCTAssertTrue(true, "Decoding error occurred as expected.")
        } catch {
            XCTFail("Unexpected error type thrown: \(error)")
        }
    }

    func testFetchRecipesWithMalformedData() async {
        let service = MockRecipeService(endpoint: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json")!)

        // Accessing the view model on the main actor
        await MainActor.run {
            let viewModel = RecipeViewModel(recipeService: service)
            Task {
                await viewModel.fetchRecipes()
                XCTAssertTrue(viewModel.recipes.isEmpty, "Recipes should be empty when the data is malformed.")
                XCTAssertEqual(viewModel.errorMessage, "Failed to load recipes. Please try again later.")
            }
        }
    }

    func testFetchRecipesWithEmptyData() async {
        let service = MockRecipeService(endpoint: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json")!)

        // Accessing the view model on the main actor
        await MainActor.run {
            let viewModel = RecipeViewModel(recipeService: service)
            Task {
                await viewModel.fetchRecipes()
                XCTAssertTrue(viewModel.recipes.isEmpty, "Recipes should be empty when no data is returned.")
                XCTAssertNil(viewModel.errorMessage, "Error message should be nil when data is empty but valid.")
            }
        }
    }
}
