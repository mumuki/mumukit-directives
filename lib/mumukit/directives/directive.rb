class Mumukit::Directives::Directive
  attr_writer :comment_type

  def comment_regexp
    /#{comment_type.open_comment}#{regexp}#{comment_type.close_comment}/
  end

  def comment_type
    @comment_type ||= Mumukit::Directives::CommentType::Cpp
  end

end