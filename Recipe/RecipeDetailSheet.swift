//
//  RecipeDetailSheet.swift
//  Recipe
//
//  Created by Shivani Gupta on 10/17/24.
//

import SwiftUI

struct RecipeDetailSheet: View {
    let recipe: Recipe
    @Binding var isPresented: Bool
    @State private var showAlert = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Spacer()
                Button(action: {
                    isPresented = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                }
            }
            .padding(.trailing)

            if let url = URL(string: recipe.photoUrlLarge) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(12)
                        .shadow(radius: 5)
                } placeholder: {
                    ProgressView()
                        .frame(width: 300, height: 200)
                }
            }

            Text(recipe.name)
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 10)
            
            Text("Cuisine: \(recipe.cuisine)")
                .font(.headline)
                .foregroundColor(.orange)

            if let sourceUrl = recipe.sourceUrl, !sourceUrl.isEmpty {
                Link("View Full Recipe", destination: URL(string: sourceUrl)!)
                    .font(.body)
                    .foregroundColor(.blue)
                    .padding(.top, 10)
            }

            Spacer()

            // Button to open YouTube link
            if let youtubeUrl = recipe.youtubeUrl, !youtubeUrl.isEmpty {
                Button(action: {
                    showAlert = true
                }) {
                    Text("Watch on YouTube")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top, 20)
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Open YouTube"),
                        message: Text("Do you want to open this video on YouTube?"),
                        primaryButton: .default(Text("Yes"), action: {
                            if let url = URL(string: youtubeUrl) {
                                UIApplication.shared.open(url)
                            }
                        }),
                        secondaryButton: .cancel()
                    )
                }
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 10)
    }
}
