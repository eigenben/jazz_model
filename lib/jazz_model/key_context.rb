module JazzModel
  # Key context is a module intended to be mixed in to classes requiring
  # the notion of "key context".  Concepts such as chords and scales exist
  # as mathematical relationships absent key, but can be put into key context.
  # Adds a key attribute to the including class and two new methods:
  #
  # * +in_key_of+(new_key) - Sets the key context to the specified new_key.
  # * +without_key+ - Removes key context.
  #
  module KeyContext
    attr_accessor :key

    def in_key_of(name)
      self.key = name.is_a?(Key) ? name : Key.find_by_name(name)
      self
    end
    alias_method :in, :in_key_of

    def without_key
      self.key = nil
      self
    end

    # Yields each way +symbol+ can be read as an optional key prefix followed
    # by the rest of the symbol, longest key first and finally with no key at
    # all.  For example "Cb5" yields [Cb, "5"], [C, "b5"], then [nil, "Cb5"],
    # letting callers pick the first reading that resolves to something.
    def self.each_split(symbol)
      return enum_for(:each_split, symbol) unless block_given?

      Key.all.sort_by { |k| -k.name.length }.each do |k|
        yield k, symbol.delete_prefix(k.name).strip if symbol.start_with?(k.name)
      end
      yield nil, symbol
    end
  end
end
