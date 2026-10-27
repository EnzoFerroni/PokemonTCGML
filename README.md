# PokemonTCGML

[![macOS](https://img.shields.io/badge/macOS-13.3%2B-000000?logo=apple)](https://developer.apple.com/macos/)
[![Swift](https://img.shields.io/badge/Swift-5-F05138?logo=swift&logoColor=white)](https://swift.org)
[![Core ML](https://img.shields.io/badge/Core%20ML-Create%20ML-34C759)](https://developer.apple.com/documentation/coreml)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

A macOS card game based on Pokémon TCG Pocket where a Core ML model predicts the opponent's best counter-play.

<img width="910" alt="Game screen" src="https://github.com/user-attachments/assets/35ffc079-f62c-4446-87a2-69e9bf74d494" />

## Table of Contents

- [About](#about)
- [How It Works](#how-it-works)
- [Results](#results)
- [Built With](#built-with)
- [Getting Started](#getting-started)
- [Future Work](#future-work)
- [References](#references)
- [License](#license)

## About

This project explores how a simple supervised model can drive in-game decisions. It
was written up as a short scientific-style article for a Mackenzie course (2025). The
player is dealt five Pokémon cards; when they pick one, a Core ML classifier predicts
which element the opponent should play to exploit that card's weakness.

## How It Works

1. **Data collection.** Card data (name, type, subtype, element, weakness) comes from
   the open [Pokémon TCG Pocket card database](https://github.com/hugoburguete/pokemon-tcg-pocket-card-database),
   filtered to Basic Pokémon and exported to `cards.csv`.
2. **Dataset.** An early version modeled the opponent's five-card hand. The final
   version simplifies the task to the ideal choice given the player's card: inputs
   `input_element` and `input_weakness`, target `ideal_choice`. 3,000 synthetic
   samples were generated, split 80/20 into `train.csv` and `test.csv`.
3. **Training.** Create ML's Tabular Classification template, exported as
   `ModeloPokemonNew.mlmodel` (the earlier hand-based model is kept as
   `ModeloPokemonOld.mlmodel`).
4. **App.** SwiftUI deals a new hand on "New Match", highlights the selected card and
   shows the model's prediction.

## Results

The simplified model predicts the counter element reliably, since the target is
fully determined by the card's weakness. Dropping the opponent's hand made the model
more direct and accurate for basic strategic behavior.

| New match | Prediction |
| :---: | :---: |
| <img width="440" alt="New match" src="https://github.com/user-attachments/assets/17601f47-d83e-4d37-9800-e020f75eb65d" /> | <img width="440" alt="Prediction" src="https://github.com/user-attachments/assets/5f5406f0-b966-44d0-92ae-6ffb61af8ff6" /> |

## Built With

- SwiftUI (macOS)
- Core ML and Create ML (Tabular Classification)

## Getting Started

Requirements: macOS 13.3 or later and Xcode 15 or later.

```bash
git clone https://github.com/EnzoFerroni/PokemonTCGML.git
cd PokemonTCGML
open PokemonTCGPocketPC/PokemonTCGPocketPC.xcodeproj
```

Select "My Mac" and press Run.

## Future Work

- Add more attributes (HP, rarity, attacks)
- Learn from previous plays with a sequential model
- Take the opponent's available cards into account
- Port to iOS and show card artwork

## References

- Apple. [Create ML documentation](https://developer.apple.com/documentation/createml)
- Apple. [Core ML documentation](https://developer.apple.com/documentation/coreml)
- [Pokémon TCG Pocket card database](https://github.com/hugoburguete/pokemon-tcg-pocket-card-database)

## License

Released under the [MIT License](LICENSE). Copyright (c) 2025 Enzo Ferroni. Pokémon
and card names are trademarks of their respective owners.
