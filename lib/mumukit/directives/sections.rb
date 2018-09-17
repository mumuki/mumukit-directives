# `Sections` directive allows code to be splitted into
# zero or more parts, using markup-like delimiter.
#
# The transformed result is a hash that replaces the
# key's content with the included sections. For example, if the `extra`
# key has two sections `foo` and `bar`...
#
# ```
# # Input
# { extra: 'foo /*<baz#*/lalala/*#baz>*/ ignored /*<bar#*/lelele/*#bar>*/' }
# ```
#
# ... the resultant hash will contain
# the `foo` and `bar` keys, and no  `extra` key:
#
# ```
# # Output
# { baz: 'lalala', bar: 'lelele' }
# ```
#
# Alternatively, if the `nest_sections` option is enabled...
#
# ```
# Mumukit::Directives::Sections.new nest_sections: true
# ```
#
# ...instead of replacing the original parent section, the new child sections are nested into it:
#
# ```
# # Output
# { extra: { baz: 'lalala', bar: 'lelele' } }
# ```

class Mumukit::Directives::Sections < Mumukit::Directives::Directive
  def initialize(options={})
    @nest_sections = !!options[:nest_sections]
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
      merge_sections! result, key, code, split_sections(code)
    end
    result
  end

  def join(sections)
    file_declarations, _file_references = sections.map do |section, content|
      [build(section, content), interpolate(section)]
    end.transpose

    file_declarations.join "\n"
  end

  def build(section, content)
    "#{comment_type.comment "<#{section}#"}#{content}#{comment_type.comment "##{section}>"}"
  end

  def interpolate(section)
    comment_type.comment("...#{section}...")
  end

  private

  def merge_sections!(result, key, code, new_sections)
    if new_sections.blank?
      result[key] = code
    elsif @nest_sections
      merge_parent_key! result, key, new_sections
    else
      merge_child_keys! result, key, new_sections
    end
  end

  def merge_child_keys!(result, key, new_sections)
    result.merge! new_sections
  end

  def merge_parent_key!(result, key, new_sections)
    result[key] = new_sections
  end
end
