module JazzModel
  # Mode context is a module intended to be mixed in to classes requiring
  # the notion of "mode context".  Right now the only class that uses this
  # is scale.  Mode context allows scales to take on a mode context which
  # effectively offsets tone sequences to retrieve tones in the given scale mode.
  #
  # * +in_mode(new_mode)+ - Sets the mode context to the specified mode (integer or name).
  # * +without_mode+ - Removes mode context.
  #
  module ModeContext
    attr_accessor :mode

    def in_mode(value)
      if value.is_a?(String)
        mode_object = respond_to?(:modes) ? modes.find_by_name(value) : Mode.find_by_name(value)
        self.mode = mode_object.mode unless mode_object.nil?
      else
        self.mode = value
      end
      self
    end

    def without_mode
      self.mode = nil
      self
    end
  end
end
