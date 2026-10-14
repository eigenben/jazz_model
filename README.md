# Jazz Model

[![CI](https://github.com/eigenben/jazz_model/actions/workflows/ci.yml/badge.svg)](https://github.com/eigenben/jazz_model/actions/workflows/ci.yml)
[![Gem Version](https://img.shields.io/gem/v/jazz_model.svg)](https://rubygems.org/gems/jazz_model)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE.txt)

An ActiveRecord object model of jazz theory. Resolve chord symbols, spell chords and scales correctly in any key, and walk the relationships between chords, scales, and modes.

```ruby
Chord["Bmaj7#11"].notes
# => ["B", "D#", "F#", "A#", "E#"]   # E#, not F: theoretically correct spelling

Scale["Melodic Minor"]["Super Locrian"].notes
# => ["B", "C", "D", "Eb", "F", "G", "A"]

Scale["Major"]["Dorian"].chords.symbols
# => ["min", "min7", "min6"]
```

## How it works

Every chord, scale, and mode is defined as a mathematical system: a sequence of **semitone offsets** (0–11) paired with **letter offsets** (0–6). Transposing to a new key is modular arithmetic on both, and the letter offset is what lets Jazz Model tell `E#` from `F` and `Cb` from `B` rather than just naming pitches.

All of the theory, such as which tones make up a C7 or which modes fit a min7 chord, lives in data rather than code. Definitions populate an in-memory SQLite database through ActiveRecord, so the whole model can be queried and traversed with familiar associations.

## Installation

Add the gem to your Gemfile:

```ruby
gem "jazz_model"
```

Then load the default definitions when your application boots:

```ruby
require "jazz_model"
JazzModel::Base.load_definitions

# or, equivalently
require "jazz_model/definitions"
```

Requires Ruby 3.2+ and ActiveRecord 7.2 or 8.x.

## Usage

Everything lives under the `JazzModel` namespace. The examples below assume `include JazzModel`.

### Chords

```ruby
Chord["maj7"]           # without key context (defaults to C)
Chord["Bbmaj7"]         # with key context
Chord["Abmaj7#11"].name
# => "Major 7 #11"

Chord["Ebmaj7"].notes
# => ["Eb", "G", "Bb", "D"]

Chord["maj7"].in_key_of("Eb").notes
# => ["Eb", "G", "Bb", "D"]

Chord["F7b9#9"].notes
# => ["F", "A", "Eb", "Gb", "G#", "C#"]

# Enharmonic keys are spelled from their own letter names
Chord["Gbmaj7"].notes
# => ["Gb", "Bb", "Db", "F"]
Chord["F#maj7"].notes
# => ["F#", "A#", "C#", "E#"]
```

### Scales and modes

```ruby
Scale["Major"].notes
# => ["C", "D", "E", "F", "G", "A", "B"]

Scale["Eb Major"].notes                  # same as Scale["Major"].in_key_of("Eb")
# => ["Eb", "F", "G", "Ab", "Bb", "C", "D"]

Scale["Whole Tone"].notes
# => ["C", "D", "E", "F#", "G#", "Bb"]

Scale["Bebop"].notes
# => ["C", "D", "E", "F", "G", "A", "Bb", "B"]

# Modes by name or number
Scale["Major"]["Dorian"]                 # same as Scale["Major"].modes["Dorian"]
Scale["Major"][2]

Scale["Major"].in_key_of("Eb")["Dorian"].notes
# => ["F", "G", "Ab", "Bb", "C", "D", "Eb"]

Scale["Melodic Minor"]["Lydian Dominant"].notes
# => ["F", "G", "A", "B", "C", "D", "Eb"]
```

### Chord–scale relationships

```ruby
Chord["min7"].modes.map(&:name)
# => ["Dorian", "Aeolian"]

Scale["Major"][4].chords.symbols
# => ["maj7#11"]

Scale["Major"].chords.map { |c| "#{c.name}: #{c.notes.join(", ")}" }
# => ["Major Triad: C, E, G",
#     "Major 7: C, E, G, B",
#     "Major 6: C, E, G, A",
#     "Dominant 6/9: C, E, G, Bb, D, A"]
```

### Identifying chords from notes

```ruby
NotesCollection["C E G A"].chords.symbols
# => ["C6", "Amin7"]

NotesCollection["C E G A"].in_key_of("A").chords.symbols
# => ["Amin7"]
```

## Definitions

Definitions are packaged sets of instructions that create the model's data. Two ship with the gem:

- **`keys`**: the 12 pitch classes and their enharmonic spellings. Always load this for Western harmony.
- **`default`**: scales, modes, chords, chord symbols, and chord–scale relationships. Depends on `keys`.

`JazzModel::Base.load_definitions` loads `default` (and therefore `keys`). Pass a name to load something else:

```ruby
JazzModel::Base.load_definitions(:my_custom_set)
```

### Writing your own

Definitions declare dependencies like Rake tasks:

```ruby
JazzModel::Definition.define my_definition: [:keys] do
  JazzModel::Scale.create!(name: "Hirajoshi").tap do |s|
    s.tones.create([
      {tone: 0, letter_index: 0},
      {tone: 2, letter_index: 1},
      {tone: 3, letter_index: 2},
      {tone: 7, letter_index: 4},
      {tone: 8, letter_index: 5}
    ])
    s.modes.create!(mode: 1, name: "Hirajoshi")
  end
end
```

See [`lib/jazz_model/definitions`](lib/jazz_model/definitions) for complete examples.

## Development

```sh
bundle install
bundle exec rake          # runs the specs and Standard
```

To run the specs against ActiveRecord 7.2:

```sh
BUNDLE_GEMFILE=gemfiles/activerecord_7_2.gemfile bundle install
BUNDLE_GEMFILE=gemfiles/activerecord_7_2.gemfile bundle exec rspec
```

## Ideas

- Chord progression analysis
- MIDI input and output
- Melodic material and licks
- Fuller voicing support

## History

Jazz Model began in 2008 as the engine behind a jazz theory web app and was extracted into a gem in 2010. In 2026 it was updated for current Ruby and ActiveRecord.

## License

Released under the [MIT License](LICENSE.txt).
