class Mumukit::Directives::Pipeline
  def initialize(directives, comment_type=nil)
    @directives = directives
    configure(comment_type)
  end

  def transform(request)
    base_sections = request.to_stringified_h
    rest = base_sections.slice!('test', 'extra', 'content', 'query')

    @directives
        .inject(base_sections) { |sections, it| it.transform(sections) }
        .amend(rest)
        .to_struct
  end

  private

  def configure(comment_type)
    @directives.each do |it|
      it.comment_type = comment_type
    end
  end
end

module Mumukit::Directives::NullPipeline
  def self.transform(request)
    request
  end
end
