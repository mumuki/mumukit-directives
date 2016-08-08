module Mumukit::Directives::CommentType
  module Cpp
    def self.open_comment
      '/*'
    end

    def self.close_comment
      '*/'
    end
  end

  class Ruby
    def self.open_comment
      '#'
    end

    def self.close_comment
      '#'
    end
  end

  class Haskell
    def self.open_comment
      '{-'
    end

    def self.close_comment
      '-}'
    end
  end

end