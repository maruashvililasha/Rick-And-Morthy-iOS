# Rick and Morty iOS App

This is an iOS app built using **SwiftUI**, following the **MVVM** architecture, and using **Combine** for handling asynchronous API requests to fetch data from the **Rick and Morty API**.

## Features

- List of Rick and Morty characters, episodes, and locations.
- Tap an image to see it fullscreen with smooth animations.
- Infinite scrolling with lazy loading.
- SwiftUI-based UI with Combine for API service.
- **Unit tests** for API services (characters, episodes, and locations).

## Unit Tests

The project includes comprehensive unit tests for the API services, ensuring the correctness of the network layer and the data handling logic. Tests have been written for the following services:

- **CharactersService**:
  - Fetching a list of characters.
  - Fetching a single character.
  - Handling errors when fetching data.

- **EpisodesService**:
  - Fetching a list of episodes.
  - Fetching a single episode.
  - Handling errors when fetching data.

- **LocationsService**:
  - Fetching a list of locations.
  - Handling errors when fetching data.

The tests utilize **Combine** and **XCTest** with mock data responses and ensure that the network requests return the expected results, including success and failure scenarios.


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
    └── CharactersServiceTests.swift
    └── EpisodesServiceTests.swift
    └── LocationServiceTests.swift
```
