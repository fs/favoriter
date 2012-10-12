module Favoriter::Tweet
  class Favorite < Base
    def to_partial_path
      'boxes/twitter/favorite'
    end
  end
end