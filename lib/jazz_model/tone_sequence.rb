module JazzModel
  # This module is mixed in wherever a collection of tones is being returned
  # and handles some of the fundamental logic involved in key and mode calculations
  # and note values.
  #
  module ToneSequence
    # Takes manually specified key context for this collection or
    # delegates to the association owner.
    def key
      @key || (owner.key if owner.respond_to?(:key))
    end

    # Manually specifies the key context for this tone sequence only.
    def in_key_of(in_key = nil)
      @key = in_key.is_a?(String) ? Key[in_key] : in_key
      self
    end

    # Takes manually specified mode context for this collection or
    # delegates to the association owner.
    def mode
      @mode || (owner.mode if owner.respond_to?(:mode))
    end

    # Manually specifies the mode context for this tone sequence only.
    def in_mode(mode)
      @mode = mode
      self
    end

    # Returns the tones ordered by position with key and mode context applied.
    # Each tone is a copy, so the underlying records are never modified.
    def in_context
      tones = to_a
      tones.map do |tone|
        tone.dup.tap do |t|
          if key
            t.tone = (tone.tone + key.index) % 12
            t.letter_index = (tone.letter_index + key.letter_index) % 7
          end
          t.position = (tone.position - mode) % tones.size + 1 if mode
        end
      end.sort_by(&:position)
    end

    # Does the magic in determining the actual note from the tones
    # with tone and letter indexes.
    def notes
      in_context.map do |tone|
        Key.from_index(tone.tone, tone.letter_index).name
      end
    end

    private

    def owner
      proxy_association.owner if respond_to?(:proxy_association)
    end
  end
end
