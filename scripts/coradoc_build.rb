# frozen_string_literal: true

require 'coradoc'
require 'coradoc/asciidoc'
require 'coradoc/html'

module CoradocBuild
  DEFAULT_CSS_THEME = 'professional'

  def self.build_file(path, css_theme: DEFAULT_CSS_THEME)
    content = File.read(path)
    doc = Coradoc::AsciiDoc.parse(content)
    expanded = doc.expand_includes(File.dirname(path))
    core = Coradoc::AsciiDoc::Transform::ToCoreModel.transform(expanded)

    css = Coradoc::Html::Config.embedded_stylesheet(css_theme: css_theme)
    config = Coradoc::Html::Static::Configuration.new(
      include_toc: true,
      toc_levels: 4,
      section_numbering: true,
      section_numbering_levels: 3,
      custom_css: css,
      lang: 'en'
    )
    Coradoc::Html::Static.convert(core, config)
  end

  def self.write(html, output_path)
    FileUtils.mkdir_p(File.dirname(output_path))
    File.write(output_path, html)
    html
  end

  def self.leak_count(html)
    html.scan('Coradoc::Html::Drop').length
  end
end
