module Mumukit::Directives::CommentType
  def self.parse(string)
    case string
      when 'ruby' then
        Mumukit::Directives::Ruby
      when 'haskell' then
        Mumukit::Directives::Haskell
      else
        Mumukit::Directives::Cpp
    end
  end

  module Cpp
    def self.open_comment
      /\/\*/
    end

    def self.close_comment
      /\*\//
    end

    def self.to_s
      'cpp'
    end
  end

  module Ruby
    def self.open_comment
      /#/
    end

    def self.close_comment
      /#/
    end

    def self.to_s
      'ruby'
    end
  end

  module Haskell
    def self.open_comment
      /\{-/
    end

    def self.close_comment
      /-\}/
    end

    def self.to_s
      'haskell'
    end
  end

end