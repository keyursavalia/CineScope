<h1 align="center">CineScope</h1>

<p align="center">
  A native iOS app for searching and exploring movies, TV series, and people — powered by TMDB — with fast results and rich detail pages.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/platform-iOS%2026%2B-black?style=flat-square" />
  &nbsp;
  <img src="https://img.shields.io/badge/language-Swift-orange?style=flat-square" />
  &nbsp;
  <img src="https://img.shields.io/badge/UI-UIKit-blue?style=flat-square" />
  &nbsp;
  <img src="https://img.shields.io/badge/TMDB-integrated-darkgreen?style=flat-square" />
  &nbsp;
  <img src="https://img.shields.io/badge/dependencies-none-brightgreen?style=flat-square" />
  &nbsp;
  <img src="https://img.shields.io/badge/license-MIT-lightgrey?style=flat-square" />
</p>

---

## What It Is

CineScope is a UIKit-based iOS app that turns the TMDB catalogue into a fast, browseable reference. One search bar surfaces movies, TV series, and people simultaneously — no separate tabs, no mode switching. Results land in a mixed list and route automatically to the right detail experience based on media type.

A movie taps through to a full detail screen: poster, rating, genre pills, runtime and release date, a horizontally scrollable cast row of up to twenty members, and a paged backdrop gallery of up to fifteen images sorted by quality. A TV series gets the same treatment, with status, year range, and season and episode counts layered on top. A person opens a biography screen with birth date, age, department tag, an image carousel pulled from their TMDB profile photos, and a full biography.

Genre mappings are cached locally so the app can label results immediately without a round trip. The cache refreshes from TMDB every seven days in the background without the user noticing.

No account. No subscription. No third-party packages. Everything is URLSession, UIKit, Core Data, and Swift Concurrency.

---

## Features

### Search

- A single **multi-search** endpoint queries TMDB for movies, TV series, and people in one request — the result list is mixed and sorted by relevance
- Custom `SearchBarView` built in UIKit with a delegate-based interface; keyboard dismisses on scroll drag
- **Scroll-to-hide search bar** — the bar slides out of view as you scroll down results and slides back in when you scroll up, keeping as much content on screen as possible
- Each result cell shows a thumbnail, title, media type badge, and vote average pulled asynchronously without blocking the main thread
- Tapping a result routes to the correct detail screen automatically based on the `mediaType` field returned by TMDB (`movie`, `tv`, or `person`)

### Movie Detail

- Full-width poster with a drop shadow, title, and a color-coded rating badge (green ≥ 7.0, orange ≥ 5.0, red below)
- Genre pills in a horizontal scroll view — genres resolved from the detail endpoint, falling back to the cached genre dictionary
- Runtime and release date formatted and displayed as a single metadata line
- Overview text in a rounded secondary-background container
- **Cast carousel** — horizontally scrollable collection view, top 20 cast members sorted by billing order, each showing a profile photo and character name; tapping a cast member navigates to their person detail screen
- **Backdrop gallery** — paged compositional layout with group-paging centering, top 15 backdrops sorted by vote average, a `UIPageControl` tracking the current page

### Series Detail

- Identical poster, rating, genre, and overview layout as movie detail
- Additional metadata: air status (e.g., Returning Series, Ended), year range, season count, and episode count

### Person Detail

- Name, known-for department tag, birth date and birthplace, age, and (if applicable) death date rendered in red
- **Image carousel** — horizontally paged scroll view of up to 20 profile photos sorted by vote average, lazy-loaded asynchronously
- Biography in a rounded container below the carousel
- Navigable from cast cells on any movie or series detail screen

### Genre Cache

- TMDB genre IDs are fetched once on launch via `GenreManager` and written to Core Data
- Subsequent launches read from Core Data immediately, with a background refresh if the data is older than seven days
- Genre names are resolved on both the search results list and detail screens without extra network calls

---

## How Search and Routing Work

A single search triggers one request to the TMDB `/search/multi` endpoint. The response is a heterogeneous list of `MediaItem` objects — each carries a `mediaType` field alongside whichever fields are relevant to its type (title vs. name, poster vs. profile photo, genres vs. known-for department).

When the user taps a result, `SearchResultsViewController` reads `mediaType` and instantiates the correct view controller:

- `movie` → `MovieDetailViewController`
- `tv` → `SeriesDetailViewController`
- `person` → `PersonDetailViewController`

Each detail view controller shares the same `MediaViewModel` instance injected at creation. The view model dispatches three concurrent async tasks when a detail screen loads — one for the full detail object, one for credits, one for images — and delivers each independently to the view as it completes. This means the screen populates progressively: metadata appears first, then cast, then gallery, without any single fetch blocking the others.

All image loading goes through `ImageService`, which wraps `URLSession.data(from:)` in an async function. Images are fetched on demand as cells become visible and are not cached to disk — the in-memory fetch is fast enough for the use case and avoids managing a cache eviction policy.

---

## Tech Stack

| | |
|---|---|
| **Language** | Swift |
| **UI Framework** | UIKit — programmatic UI and Auto Layout, no Storyboards for main views |
| **Architecture** | MVVM — `MediaViewModel` is the single shared view model; View Controllers own layout and delegate wiring |
| **Networking** | URLSession — TMDB v3 REST API with Bearer token auth |
| **Concurrency** | Swift structured concurrency — `async/await` for all network calls; `@MainActor` on the view model to keep UI updates on the main thread |
| **Persistence** | Core Data — `GenreEntity` stores genre ID-to-name mappings; `UserDefaults` stores the last genre fetch timestamp |
| **Image Loading** | `ImageService` — async `URLSession` fetches, no third-party library |
| **External API** | TMDB v3 — multi-search, movie detail, series detail, person detail, credits, images |
| **Dependency Injection** | Protocol-backed services (`MediaServiceProtocol`, `ImageServiceProtocol`) injected into the view model for testability |
| **Deployment Target** | iOS 26+ |
| **Dependencies** | None |

---

## Project Structure

```
CineScope/
├── MovieApp.xcodeproj/
│
├── MovieApp/
│   ├── AppDelegate.swift                   ← UIApplicationDelegate, genre cache refresh on launch
│   ├── SceneDelegate.swift                 ← Window setup, root navigation controller
│   │
│   ├── Configuration/
│   │   ├── APIKey.swift                    ← Reads TMDB_API_TOKEN from APIKey.plist
│   │   └── APIKey.plist                    ← Git-ignored; add your own token here
│   │
│   ├── Model/
│   │   ├── SearchResponse.swift            ← Decodable wrapper around TMDB /search/multi results
│   │   ├── Genre.swift                     ← Genre ID + name; GenreEntity for Core Data
│   │   ├── MovieDetail.swift               ← Full movie detail response + formatting helpers
│   │   ├── SeriesDetail.swift              ← Full TV series detail response + formatting helpers
│   │   ├── PersonDetail.swift              ← Full person detail response + age/birth helpers
│   │   ├── CreditsResponse.swift           ← Cast member list shared by movie and series
│   │   ├── ImagesResponse.swift            ← Backdrop list for movies and series
│   │   └── PersonImagesResponse.swift      ← Profile photo list for people
│   │
│   ├── Service/
│   │   ├── Network/
│   │   │   ├── MediaService.swift              ← URLSession client; base URL and token setup
│   │   │   ├── MediaServiceProtocol.swift      ← Full protocol surface (search, detail, credits, images)
│   │   │   ├── NetworkError.swift              ← Typed error cases (invalidURL, invalidResponse, decoding)
│   │   │   ├── Movie/
│   │   │   │   ├── MovieService.swift          ← /movie/{id}, /movie/{id}/credits, /movie/{id}/images
│   │   │   │   └── MovieServiceProtocol.swift
│   │   │   ├── Series/
│   │   │   │   ├── SeriesService.swift         ← /tv/{id}, /tv/{id}/credits, /tv/{id}/images
│   │   │   │   └── SeriesServiceProtocol.swift
│   │   │   ├── Person/
│   │   │   │   ├── PersonService.swift         ← /person/{id}, /person/{id}/images
│   │   │   │   └── PersonServiceProtocol.swift
│   │   │   ├── Search/
│   │   │   │   ├── SearchService.swift         ← /search/multi
│   │   │   │   └── SearchServiceProtocol.swift
│   │   │   └── Genre/
│   │   │       ├── GenreService.swift          ← /genre/movie/list + /genre/tv/list
│   │   │       └── GenreServiceProtocol.swift
│   │   ├── Image/
│   │   │   ├── ImageService.swift              ← async URLSession image fetch
│   │   │   └── ImageServiceProtocol.swift
│   │   ├── Genre/
│   │   │   └── GenreManager.swift              ← Singleton; loads from Core Data, refreshes every 7 days
│   │   └── Persistence/
│   │       └── CoreDataManager.swift           ← NSPersistentContainer; saveGenres + fetchGenreDictionary
│   │
│   ├── ViewModel/
│   │   ├── MediaViewModel.swift            ← @MainActor; search, build display models, fetch cast/gallery/person images
│   │   ├── MovieDisplayModel.swift         ← Value type: title, rating, genres, image, runtime, date
│   │   ├── SeriesDisplayModel.swift        ← Value type: adds status, year range, season/episode text
│   │   ├── PersonDisplayModel.swift        ← Value type: name, biography, birth info, age, deathday
│   │   └── CastDisplayItem.swift          ← Lightweight cast member: id, name, character, image
│   │
│   └── View/
│       ├── SearchBar/
│       │   ├── SearchBarView.swift         ← Custom UIView search bar with delegate protocol
│       │   └── SearchResultCell.swift      ← UITableViewCell: thumbnail, title, type badge, rating
│       ├── SearchResultsView/
│       │   ├── SearchResultsView.swift     ← UIView wrapping the results UITableView
│       │   └── SearchResultsViewController.swift  ← Root VC; scroll-to-hide bar, routing on tap
│       └── MediaDetail/
│           ├── CastCell.swift              ← Horizontal cast collection view cell
│           ├── GalleryCell.swift           ← Paged backdrop collection view cell
│           ├── MovieDetail/
│           │   ├── MovieDetailView.swift       ← Full programmatic layout: poster, metadata, cast, gallery
│           │   └── MovieDetailViewController.swift
│           ├── SeriesDetail/
│           │   ├── SeriesDetailView.swift      ← Same layout as movie, with series-specific metadata
│           │   └── SeriesViewController.swift
│           └── PersonDetail/
│               ├── PersonDetailView.swift      ← Carousel + biography layout
│               ├── PersonDetailViewController.swift
│               └── PersonImageCarouselView.swift  ← Horizontal paging image scroll view
```

---

## Getting Started

**Requirements:** Xcode 17 and an iOS 26 simulator or device. One external API key required.

```bash
git clone https://github.com/keyursavalia/CineScope.git
cd CineScope
open MovieApp.xcodeproj
```

Create `MovieApp/Configuration/APIKey.plist` and add one entry:

| Key | Type | Value |
|---|---|---|
| `TMDB_API_TOKEN` | String | Your TMDB v4 access token (without the `Bearer ` prefix) |

You can generate a free access token at [themoviedb.org/settings/api](https://www.themoviedb.org/settings/api). The token is read at launch by `APIKey.swift` and injected into every request as a Bearer authorization header.

Press `Cmd R`. The genre cache populates on first launch in the background. All search and detail functionality is live immediately — the only network dependency is TMDB.

---

## What's Next

- **Image cache** — persist loaded poster and backdrop images in memory or on disk to eliminate redundant fetches when navigating back and forth between results and detail screens
- **Watchlist** — save movies and series to a local SwiftData or Core Data store so users can build a personal queue without leaving the app
- **Person filmography** — list the complete movie and TV credits for a person on their detail screen, each one tappable to navigate directly to that title's detail page
- **Trending feed** — replace the empty initial state with a live feed of trending movies and TV pulled from TMDB, giving users a starting point without needing a search query
- **Accessibility pass** — full VoiceOver audit across the search list, cast carousel, gallery pager, and all three detail screens
- **Error state views** — replace alert dialogs with inline error states in the results list when the network is unavailable or a search returns no matches

---

## Contributing

Fork the repo, branch from `main`, one fix or feature per PR. Commit prefixes: `init:` / `add:` / `fix:` / `feat:`. Bug reports and ideas are welcome as GitHub issues.

---

## License

[MIT](LICENSE) · © 2026 Keyur Savalia
