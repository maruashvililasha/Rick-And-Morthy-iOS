
//
//  ContentView.swift
//  RickAndMorthy
//
//  Created by Lasha Maruashvili on 24.09.24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    @State private var selecetedCharacterImage: Image?
    @State private var selecetedCharacter: Character?
    @Namespace private var animationNamespace
    
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
        }.overlay {
            if let selecetedCharacterImage, let selecetedCharacter {
                ZStack(alignment: .topTrailing) {
                    Color.black.opacity(0.8)
                        .ignoresSafeArea()
                    
                    VStack {
                        Spacer()
                        // Close button
                        selecetedCharacterImage
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 30))
                            .matchedGeometryEffect(id: selecetedCharacter.id, in: animationNamespace)
                            .onTapGesture {
                                withAnimation(.bouncy) {
                                    self.selecetedCharacterImage = nil
                                    self.selecetedCharacter = nil
                                }
                            }
                            .padding()
                        
                        Button(action: {
                            withAnimation(.bouncy) {
                                self.selecetedCharacterImage = nil
                                self.selecetedCharacter = nil
                            }
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.white)
                                .padding()
                        }
                        Spacer()
                    }
                }
            }
        }
    }

    func characterView(_ character: Character) -> some View {
        HStack {
            if selecetedCharacter?.id != character.id {
                AsyncImage(url: URL(string: character.image)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 160)
                        .frame(width: 100)
                        .matchedGeometryEffect(id: character.id, in: animationNamespace)
                        .onTapGesture {
                            withAnimation(.bouncy) {
                                selecetedCharacterImage = image
                                selecetedCharacter = character
                            }
                        }
                } placeholder: {
                    ProgressView()
                        .frame(height: 160)
                        .frame(width: 100)
                }
                .cornerRadius(30)
                .shadow(radius: 5)
            } else {
                Spacer()
                    .frame(height: 160)
                    .frame(width: 100)
            }
            Spacer()
                .frame(width: 20)
            HStack {
                VStack(alignment: .leading) {
                    Text(character.name)
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("Species: \(character.species)")
                    Text("Status: \(character.status)")
                    Text("Origin: \(character.origin.name)")
                    Text("Gender: \(character.gender)")
                }
                Spacer()
            }
            .padding(.leading, 30)
            .frame(height: 160)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.white)
                    .shadow(radius: 5)
            )
        }
        .padding()
    }
}

#Preview {
    HomeView()
        .environmentObject(HomeViewModel())
}
