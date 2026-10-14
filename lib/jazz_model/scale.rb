module JazzModel
  # A scale is an ordered collection of tones.
  # 
  # == Creating a Scale
  # 
  # Scale objects should be created by indexing the +Scale+ class directly:
  # 
  #   Scale['Major']
  # 
  # An alternative method of resolving a chord is to use the +resolve+ method, 
  # though this is likely to become deprecated in the future when chord progression
  # support/representation is added:
  #
  #   Scale.resolve(name)
  #
  # == Associations
  # 
  # * +modes+ - Associated modes.
  # * +main_mode+ - Associated mode with a mode index of 1 (first mode).  This sometimes 
  #     the only defined mode such as for the whole tone scale.
  # * +tones+ - A collection of +ScaleTone+s.
  # * +notes+ - An array of notes (delegated through +tones+)
  # * +chords+ - A collection of associated chords with the first mode of this scale.
  # 
  # == Modes
  # 
  # Each scale can have one or many modes, which really define the relationship to chords. 
  # Modes are accessible like so (all methods are equal):
  # 
  #   Scale['Major']['Dorian']
  #   Scale['Major'][2]
  #   Scale['Major'].modes['Dorian']
  #   Scale['Major'].modes[2]
  # 
  # == Examples
  # 
  # === Listing Tones in Scales
  # 
  #   Scale['Major'].notes
  #   # => ["C", "D", "E", "F", "G", "A", "B"]
  #  
  #   Scale['Major'].in_key_of('Eb').notes
  #   Scale['Eb Major'].notes  # Same as above
  #   # => ["Eb", "F", "G", "Ab", "Bb", "C", "D"]
  # 
  # === Correctly Interpets Theoretical Keys (not just pitches)
  # 
  #   Scale['Gb Major'].notes
  #   # => ["Gb", "Ab", "Bb", "Cb", "Db", "Eb", "F"]
  #   # Note the use of Cb which is theoretically correct over enharmonic B.
  # 
  # Also correctly interpet tones off of enharmonic base keys:
  # 
  #   Scale['Gb Major'].notes
  #   # => ["Gb", "Ab", "Bb", "Cb", "Db", "Eb", "F"]
  #   Scale['F# Major'].notes
  #   # => ["F#", "G#", "A#", "B", "C#", "D#", "E#"]
  # 
  # === Listing Tones within the context of a mode
  # 
  #   Scale['Major'].modes['Dorian']
  #   Scale['Major']['Dorian']  # Same as above
  #   # => ["D", "E", "F", "G", "A", "B", "C"]
  #  
  #   Scale['Melodic Minor'].modes['Super Locrian'].notes
  #   # => ["B", "C", "D", "Eb", "F", "G", "A"]  # aka. Altered Scale or Dim. Whole Tone
  # 
  # == Listing Related Chords
  # 
  #   Scale['Major'].chords.symbols
  #   # => ['maj7', 'maj6', '6/9']
  #   Scale['Major']['Dorian'].chords.symbols
  #   # => ['min7', 'min6']
  #  
  class Scale < JazzModel::Base
    include KeyContext
    include ModeContext
    
    has_many :modes, extend: ModeSequence, dependent: :destroy
    has_many :tones, class_name: "ScaleTone", extend: ToneSequence, dependent: :destroy

    delegate :notes, to: :tones
    delegate :chords, to: :main_mode

    class << self
      # Resolves a scale name, optionally prefixed with a key (such as
      # "Eb Major"), into a scale.
      def resolve(symbol)
        return nil if symbol.nil?

        KeyContext.each_split(symbol) do |in_key, rest|
          scale = find_by_name(rest) or next
          scale.key = in_key
          return scale
        end
        nil
      end
      alias_method :[], :resolve
    end

    # Finds a mode of this scale by name or number, passing along key context.
    def [](name)
      modes[name]
    end

    def main_mode
      self[1]
    end

    def symmetric?
      !symmetry_index.nil?
    end
  end
end
