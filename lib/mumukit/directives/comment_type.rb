module Mumukit::Directives::CommentType
  def self.parse(string)
    case string
      when 'ruby' then
        Ruby
      when 'haskell' then
        Haskell
      else
        Cpp
    end
  end

  module Comment
    def comment(code)
      "#{open}#{code}#{close}"
    end

    def open_comment
      /#{open}/
    end

    def close_comment
      /#{close}/
    end

  end

  module Cpp
    extend Comment

    def self.open
      '/*'
    end

    def self.close
      '*/'
    end

    def self.to_s
      'cpp'
    end
  end

  module Ruby
    extend Comment

    def self.open
      '#'
    end

    def self.close
      '#'
    end

    def self.to_s
      'ruby'
    end
  end

  module Haskell
    extend Comment

    def self.open
      '{-'
    end

    def self.close
      '-}'
    end

    def self.to_s
      'haskell'
    end
  end

end