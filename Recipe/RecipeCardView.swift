//
//  RecipeCardView.swift
//  Recipe
//
//  Created by Shivani Gupta on 10/17/24.
//

import SwiftUI

struct RecipeCardView: View {
    let recipe: Recipe

    var body: some View {
        VStack(alignment: .leading) {
            if let url = URL(string: recipe.photoUrlSmall) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 150)
                        .clipped()
                        .cornerRadius(10)
                        .shadow(radius: 5)
                } placeholder: {
                    ProgressView()
                        .frame(width: 150, height: 150)
                }
            }

            VStack(alignment: .leading) {
                Text(recipe.name)
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding(.top, 5)
                    .lineLimit(1)

                Text(recipe.cuisine)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            .padding([.leading, .bottom, .trailing], 10)
        }
        .background(Color.black)
        .cornerRadius(10)
        .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 3)
    }
}
