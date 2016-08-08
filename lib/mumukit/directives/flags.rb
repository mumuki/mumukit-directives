class Mumukit::Directives::Flags < Mumukit::Directives::Directive
  def flags(code)
    code.captures(comment_regexp).map { $1 }
  end

  def regexp
    /\[(.+?)\]/
  end

  def active?(flag, code)
    flags(code).include? flag
  end

  def transform(sections)
    if active?('IgnoreContentOnQuery', sections['extra']) && sections['query'].present?
      sections.except('content')
    else
      sections
    end
  end


end