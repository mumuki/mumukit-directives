class Mumukit::Directives::Interpolations < Mumukit::Directives::Directive
  def initialize(key)
    @key = key
  end

  def regexp
    /\.\.\.(.+?)\.\.\./
  end

  def interpolations?(code)
    (code =~ comment_regexp).present?
  end

  def interpolate(code, sections)
    interpolated = []

    var = code.captures(comment_regexp) do
      interpolated << $1
      sections[$1]
    end

    [var, interpolated.uniq]
  end

  def transform(sections)
    code = sections[@key]
    if interpolations? code
      interpolation, interpolated = interpolate code, sections.except(@key)
      sections.merge(@key => interpolation).except(*interpolated)
    else
      sections
    end
  end
end
