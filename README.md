# Rick and Morty iOS App

This repository is created to demonstrate how to build an **API service** with **Combine** in **SwiftUI** and implement **MVVM** architecture. The app fetches data from the **Rick and Morty API** and displays it using smooth and elegant **animations**.

## Features

- **API Service**: Handles API requests using `Combine` to fetch data from the [Rick and Morty API](https://rickandmortyapi.com/documentation).
- **MVVM Architecture**: The app is structured using the Model-View-ViewModel (MVVM) design pattern.
- **SwiftUI Animations**: Implements small, nice animations such as scaling images to fullscreen when tapped.
- **Lazy Loading**: Fetches data page by page with infinite scrolling using a `LazyVStack`.

## Project Structure

```plaintext
RickAndMortyApp/
├-RickAndMorty/
  ├── RickAndMortyApp.swift
  ├── Home/
  │   ├── HomeView.swift
  │   └── HomeViewModel.swift
  ├── Model/
  │   ├── BaseResponse.swift
  │   └── Character.swift
  │   └── Episode.swift
  │   └── Location.swift
  ├── Network/
  │   └── APIClient/
  │       ├── ApiClient.swift
  │       └── ApiEnvironment.swift
  │       └── RequestBuilder.swift
  │       └── APIError.swift
  │   └── Routes/
  │       ├── API.swift
  │       └── Characters.swift
  │       └── Episodes.swift
  │       └── Locations.swift
  │   └── Service/
  │       ├── CharactersService.swift
  │       └── EpisodeService.swift
  │       └── LocationsService.swift
  ├── Prview Content/
  │   └── Preview Assets.swift
  ├── Resourses/
  │   └── Assets.swift
  └── RickAndMorthyTests/
    └── RickAndMorthyTests.swift
```
