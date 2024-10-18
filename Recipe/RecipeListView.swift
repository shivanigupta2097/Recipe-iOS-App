//
//  RecipeListView.swift
//  Recipe
//
//  Created by Shivani Gupta on 10/17/24.
//


import SwiftUI

struct RecipeListView: View {
    @StateObject private var viewModel = RecipeViewModel()
    @State private var searchText: String = ""
    @State private var sortOption: SortOption = .name
    @State private var showAlert = false
    @State private var alertMessage: String?

    var body: some View {
        NavigationView {
            VStack(spacing: 8) {
                // Search Bar
                SearchBar(text: $searchText) { searchTerm in
                    // Filter recipes based on the search term whenever it changes
                    viewModel.filterRecipes(with: searchTerm)
                }
                .padding(.horizontal)

                // Sort Picker
                sortPicker

                // Content
                content
                    .refreshable {
                        await viewModel.fetchRecipes()
                    }
            }
            .navigationTitle("Recipes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Refresh") {
                        Task {
                            await viewModel.fetchRecipes()
                        }
                    }
                }
            }
            .onAppear {
                Task {
                    await viewModel.fetchRecipes()
                }
            }
            .onChange(of: viewModel.errorMessage) { oldValue, newValue in
                if let newValue = newValue, newValue != oldValue {
                    alertMessage = newValue
                    showAlert = true
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(alertMessage ?? "Unknown Error"),
                    dismissButton: .default(Text("OK")) {
                        Task { @MainActor in
                            viewModel.errorMessage = nil
                        }
                    }
                )
            }
        }
    }

    // A separate view for the picker
    private var sortPicker: some View {
        Picker("Sort by", selection: $sortOption) {
            Text("Name").tag(SortOption.name)
            Text("Cuisine").tag(SortOption.cuisine)
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
    }

    // A separate view for the main content
    private var content: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading recipes...")
            } else if sortedRecipes.isEmpty {
                emptyStateView
            } else {
                recipesListView
            }
        }
    }

    // A view for the empty state
    private var emptyStateView: some View {
        VStack {
            Text("No recipes available")
                .font(.title3)
                .padding()
                .foregroundColor(.gray)
            Text("Try refreshing or checking your network connection.")
                .font(.footnote)
                .foregroundColor(.gray)
        }
    }

    // A view for the list of recipes
    private var recipesListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(sortedRecipes) { recipe in
                    RecipeRowView(recipe: recipe)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                }
            }
        }
    }

    // Computed property for sorting recipes
    private var sortedRecipes: [Recipe] {
        let filteredRecipes = viewModel.filteredRecipes.filter { recipe in
            searchText.isEmpty ||
            recipe.name.localizedCaseInsensitiveContains(searchText) ||
            recipe.cuisine.localizedCaseInsensitiveContains(searchText)
        }

        switch sortOption {
        case .name:
            return filteredRecipes.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        case .cuisine:
            return filteredRecipes.sorted { $0.cuisine.localizedCaseInsensitiveCompare($1.cuisine) == .orderedAscending }
        }
    }
}

enum SortOption {
    case name, cuisine
}
