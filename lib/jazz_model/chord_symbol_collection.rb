module JazzModel
  # Module mixin for Chord symbols
  module ChordSymbolCollection
    # Finds a chord symbol within the collection
    def resolve(symbol)
      detect { |cs| cs.matches?(symbol) }
    end
    alias_method :[], :resolve
  end
end
