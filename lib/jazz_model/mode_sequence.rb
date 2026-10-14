module JazzModel
  # Extends the Scale.modes association by allowing indexed access to modes.
  # When using it in this manner, key context is passed along.
  #
  module ModeSequence
    def [](value)
      mode_object = where("name = ? OR mode = ?", value, value).first
      return nil if mode_object.nil?

      # Pass Along Key Information
      owner = proxy_association.owner
      mode_object.key = owner.key if owner.respond_to?(:key) && !owner.key.nil?
      mode_object
    end
  end
end
