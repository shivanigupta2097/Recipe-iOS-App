//
//  SearchBar.swift
//  Recipe
//
//  Created by Shivani Gupta on 10/17/24.
//


import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    @State private var isEditing = false
    
    // Define a closure to handle search logic from the parent view or view model
    var onSearch: (String) -> Void

    var body: some View {
        HStack {
            TextField("Search recipes/cuisines...", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                        if isEditing {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .padding(.horizontal, 10)
                .onTapGesture {
                    self.isEditing = true
                }
                .onSubmit {
                    // Trigger search only when the user presses the return key
                    onSearch(text)
                }

            if isEditing {
                Button("Cancel") {
                    self.isEditing = false
                    self.text = ""
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
                .animation(.default, value: isEditing)
            }
        }
    }
}


