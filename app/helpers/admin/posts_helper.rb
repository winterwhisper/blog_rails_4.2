module Admin::PostsHelper

  def render_tags_input_delimiter
    Tag::SPLIT_STR.map { |str| "'#{str}'" }.join(', ').html_safe
  end

end