//
//  RecipeUITests.swift
//  RecipeUITests
//
//  Created by Shivani Gupta on 10/17/24.
//


import XCTest

final class RecipeAppUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUp() {
        continueAfterFailure = false
        app.launch()
    }

    func testRecipeListDisplay() {
        // Ensure the recipe list appears with at least one cell
        let recipeList = app.tables["recipeList"]
        XCTAssertTrue(recipeList.cells.count > 0, "The recipe list should have at least one item")
    }

    func testSearchFunctionality() {
        let searchBar = app.searchFields["Search recipes..."]
        searchBar.tap()
        searchBar.typeText("Spaghetti")

        // Verify the filtered results
        let firstCell = app.tables.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.staticTexts["Spaghetti"].exists, "The search result should display 'Spaghetti'")
    }

    func testYouTubeAlertDisplay() {
        let firstRecipe = app.tables.cells.element(boundBy: 0)
        firstRecipe.tap()

        // Tap the YouTube button and verify alert appearance
        let youtubeButton = app.buttons["Watch on YouTube"]
        youtubeButton.tap()

        let alert = app.alerts["Open YouTube"]
        XCTAssertTrue(alert.exists, "An alert should appear when attempting to open the YouTube link")
    }
}
