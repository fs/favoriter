class Twitter::Action::Tweet
  def to_partial_path
    "boxes/twitter/#{self.class.to_s.demodulize.underscore}"
  end
end