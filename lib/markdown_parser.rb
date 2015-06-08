class MarkdownParser

  def initialize
    @renderer = Redcarpet::Render::HTML.new(
      filter_html: true,
      with_toc_data: true,
      hard_wrap: true,
      link_attributes: true
    )
    @parser = Redcarpet::Markdown.new(@renderer, no_intra_emphasis: true,
                                                 tables: true,
                                                 fenced_code_blocks: true,
                                                 disable_indented_code_blocks: true,
                                                 strikethrough: true,
                                                 space_after_headers: true,
                                                 underline: true,
                                                 highlight: true,
                                                 quote: true,
                                                 footnotes: true)
  end

  attr_reader :parser

  private_class_method :new

  def self.instance
    new.parser
  end

end