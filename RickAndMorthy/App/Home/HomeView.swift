
//
//  ContentView.swift
//  RickAndMorthy
//
//  Created by Lasha Maruashvili on 24.09.24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    
    var body: some View {
        ZStack {
            VStack {
                Text("Rick and Morty")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        ForEach(viewModel.characters, id: \.id) { character in
                            characterView(character)
                                .onAppear {
                                    viewModel.fetchNextPageIfNeeded(currentCharacter: character)
                                }
                        }
                    }
                }
            }
        }.onAppear() {
            viewModel.fetchCharacters(page: 1)
        }.overlay {
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            }
        }
        
    }

    func characterView(_ character: Character) -> some View {
        HStack {
            AsyncImage(url: URL(string: character.image)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(height: 140)
            } placeholder: {
                ProgressView()
                    .frame(height: 140)
                    .frame(width: 140)
            }
            .cornerRadius(30)
            .shadow(radius: 5)
            Spacer()
                .frame(width: 20)
            VStack(alignment: .leading) {
                Text(character.name)
                    .font(.title2)
                    .fontWeight(.bold)
                Text("Species: \(character.species)")
                Text("Status: \(character.status)")
            }
        }.padding()
    }
}

#Preview {
    HomeView()
        .environmentObject(HomeViewModel())
}
