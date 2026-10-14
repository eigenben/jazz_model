module JazzModel
  # A chord object represents a chord defined as an unordered collection of tones (non-octaval).
  # Mixes in the +KeyContext+ module to provide optional key context on the chord.
  #
  # == Creating a Chord
  #
  # Chords should be created by indexing the +Chord+ class like an array, like so:
  #
  #   Chord[symbol]
  #
  # An alternative method of resolving a chord is to use the +resolve+ method,
  # though this is likely to become deprecated in the future when chord progression
  # support/representation is added:
  #
  #   Chord.resolve(symbol)
  #
  # This resolves a specified chord symbol into a new chord object using
  # data regarding chord symbol-to-chord relationships.
  # +symbol+ can be any standard jazz chord symbol representable as
  # plain ASCII (unicode support for other symbols such as full-diminished circle
  # in the works). Can be prefixed with a key.
  #
  # == Object Relationships
  #
  # A chord object has the following associations, exposed by methods:
  #
  # * +symbols+ - Associated chord symbols.
  # * +primary_symbol+ - Primary chord symbol.
  # * +chord_scales+ - Chord-scale relationship objects.  See ChordScale.
  # * +modes+ - Direct access to associated scale modes through +chord_scales+.
  # * +tones+ - Sequence of tones associated with the chord.  See +ToneSequence+.
  # * +voicings+ - Voicings associated with this chord.#
  #
  # == Example Usage
  #
  # === Creating Chords Without Key Context
  #
  #   Chord['maj']
  #   Chord['min7'
  #   Chord['maj7#11']
  #   Chord['7#9']
  #
  # === Creating Chords With Key Context
  #
  #   Chord['C7']
  #   Chord['Bbalt']
  #   Chord['Gbmaj7']
  #
  # === Getting Chord Notes
  # Use +notes+ to retrieve a collection of notes, which actually delegates to +tones.notes+:
  #
  #   Chord['C7'].notes
  #   # => ['C', 'E', 'G', 'Bb']
  #
  #   Chord['Cmaj7#11'].notes
  #   # => ["C", "E", "G", "B", "F#"]
  #
  # === Correctly Interpets Theoretical Keys (not just pitches)
  # Note the #11 is correctly interpreted as E# and not enharmonic F here:
  #
  #   Chord['Bmaj7#11'].notes
  #   # => ["B", "D#", "F#", "A#", "E#"]
  #
  # Also correctly interpet tones off of enharmonic base keys:
  #
  #   Chord['Gbmaj7'].notes
  #   # => ["Gb", "Bb", "Db", "F"]
  #   Chord['F#maj7'].notes
  #   # => ["F#", "A#", "C#", "E#"]
  #
  # === See Related Scales
  #
  #   Chord['min7'].modes.names  # .names == .map(&:name)
  #   # => ['Dorian']
  #   Chord['min7'].modes[0].scale.name
  #   # => "Major"
  #
  #   Chord['Amin7'].modes.names
  #   # => ['A Dorian']
  #
  class Chord < JazzModel::Base
    include ActsAsTree
    include KeyContext

    acts_as_tree

    belongs_to :chord_quality

    has_many :symbols, class_name: "ChordSymbol", extend: ChordSymbolCollection
    has_one :primary_symbol, -> { where(primary: true) }, class_name: "ChordSymbol"

    has_many :chord_scales
    has_many :modes, through: :chord_scales
    has_many :tones, class_name: "ChordTone", extend: ToneSequence
    has_many :voicings

    delegate :notes, to: :tones

    def symbols_list
      symbols.map(&:name).join(", ")
    end

    class << self
      # Resolves a chord symbol, optionally prefixed with a key, into a chord.
      # Ambiguous prefixes are tried longest key first, so "Cbmaj7" is a C-flat
      # major 7th while "Cb5" falls back to a C chord with a flat 5th.
      def resolve(symbol)
        return nil if symbol.nil?

        KeyContext.each_split(symbol) do |in_key, rest|
          chord_symbol = ChordSymbol[rest] or next
          chord = chord_symbol.chord
          chord.key = in_key
          return chord
        end
        nil
      end
      alias_method :[], :resolve
    end
  end
end
