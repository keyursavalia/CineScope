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
