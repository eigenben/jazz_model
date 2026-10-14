module JazzModel
  # Intended to be used as a dynamic object extension of an Array representing 
  # a collection of chords for some added convenience.
  # 
  # For example, even though the base class is an Array, we can write:
  # 
  # * +scale.chords.symbols+ - For an array of symbols.
  # * +scale.chords.names+ - For an array of full names.
  # 
  module ChordCollection
  
    # Formats chord collection
    def to_s(format = :symbols)
      case format
      when :symbols then symbols.join(', ')
      when :names then names.join(', ')
      end
    end
  
    # Returns array of chord symbols only
    def symbols
      map { |c| "#{c.key&.name}#{c.primary_symbol.name}" }
    end

    # Returns array of chord names only
    def names
      map { |c| "#{c.key&.name} #{c.name}".strip }
    end

    # Resolves a chord symbol, optionally prefixed with a key, into one of the
    # chords in this collection.  See Chord.resolve.
    def resolve(symbol)
      return nil if symbol.nil?

      KeyContext.each_split(symbol) do |in_key, rest|
        chord_symbol = flat_map { |c| c.symbols.to_a }.detect { |cs| cs.matches?(rest) } or next
        chord = chord_symbol.chord
        chord.key = in_key
        return chord
      end
      nil
    end
    alias_method :[], :resolve
  end
end
