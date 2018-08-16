class Mumukit::Directives::Sections < Mumukit::Directives::Directive
  def initialize(options={})
    @preserve_parent_key = !!options[:preserve_parent_key]
  end

  def regexp
    /<(.+?)##{comment_type.close_comment}(.*?)#{comment_type.open_comment}#(.+?)>/m
  end

  def split_sections(code)
    sections = code.captures(comment_regexp).map do
      [$1, $2]
    end
    Hash[sections]
  end

  def transform(sections)
    result = {}
    sections.each do |key, code|
      new_sections = split_sections(code)
      merge_child_keys! result, key, code, new_sections
      merge_parent_key! result, key, code, new_sections
    end
    result
  end

  private

  def merge_child_keys!(result, key, code, new_sections)
    if new_sections.present?
      result.merge! new_sections
    else
      result[key] = code
    end
  end

  def merge_parent_key!(result, key, code, new_sections)
    if @preserve_parent_key
      result[key] = new_sections.presence || code
    end
  end
end
