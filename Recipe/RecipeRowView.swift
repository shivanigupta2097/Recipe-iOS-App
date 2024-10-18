//
//  RecipeRowView.swift
//  Recipe
//
//  Created by Shivani Gupta on 10/17/24.
//

import SwiftUI

struct RecipeRowView: View {
    let recipe: Recipe
    @State private var showDetails = false

    var body: some View {
        VStack {
            ZStack(alignment: .bottomLeading) {
                // Recipe Image
                if let imageUrl = URL(string: recipe.photoUrlLarge) {
                    AsyncImage(url: imageUrl) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 200)
                            .cornerRadius(12)
                            .clipped()
                    } placeholder: {
                        // Placeholder while image loads
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 200)
                            .cornerRadius(12)
                            .overlay(
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.gray)
                            )
                    }
                } else {
                    // Placeholder if the image URL is invalid
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 200)
                        .cornerRadius(12)
                        .overlay(
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.gray)
                        )
                }

                // Recipe Name and Cuisine Overlay
                VStack(alignment: .leading) {
                    Text(recipe.name.isEmpty ? "Unknown Recipe" : recipe.name)
                        .font(.headline)
                        .foregroundColor(.white)
                        .shadow(radius: 2)
                    
                    Text(recipe.cuisine.isEmpty ? "Unknown Cuisine" : recipe.cuisine)
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .shadow(radius: 2)
                }
                .padding(8)
                .background(Color.black.opacity(0.5))
                .cornerRadius(8)
                .padding([.leading, .bottom], 10)
            }
            .padding(.horizontal, 8)
            .onTapGesture {
                showDetails.toggle()
            }
            .sheet(isPresented: $showDetails) {
                // Displaying details in a sheet
                RecipeDetailSheet(recipe: recipe, isPresented: $showDetails)
            }
        }
        .padding(.vertical, 4)
    }
}
