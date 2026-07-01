# frozen_string_literal: true

require_relative 'coradoc_build'

repo_dir = File.expand_path('..', __dir__)
sources_dir = File.join(repo_dir, 'sources')
dist_dir = File.join(repo_dir, 'dist')

parts = %w[
  spec data-model process-model compliance measurement mapping
  documentation terminology workspace authoring-guide methodology-guide
]

total_bytes = 0
errors = []

parts.each do |part|
  input_path = File.join(sources_dir, part, 'document.adoc')
  output_path = File.join(dist_dir, part, 'index.html')

  unless File.exist?(input_path)
    puts "SKIP: #{part}"
    next
  end

  begin
    html = CoradocBuild.build_file(input_path)
    CoradocBuild.write(html, output_path)
    leaks = CoradocBuild.leak_count(html)
    puts "#{leaks == 0 ? 'OK' : "LEAKS: #{leaks}"}: #{part} (#{html.size} bytes)"
    total_bytes += html.size
    errors << part if leaks > 0
  rescue StandardError => e
    puts "ERROR: #{part}: #{e.message}"
    errors << part
  end
end

puts ""
puts "#{parts.length} parts, #{total_bytes} bytes, #{errors.empty? ? 'all clean' : "errors in: #{errors.join(', ')}"}"

index_input = File.join(sources_dir, 'index.adoc')
if File.exist?(index_input)
  begin
    html = CoradocBuild.build_file(index_input)
    CoradocBuild.write(html, File.join(dist_dir, 'index.html'))
    leaks = CoradocBuild.leak_count(html)
    puts "#{leaks == 0 ? 'OK' : "LEAKS: #{leaks}"}: index (#{html.size} bytes)"
  rescue StandardError => e
    puts "ERROR: index: #{e.message}"
    errors << 'index'
  end
end

exit(errors.empty? ? 0 : 1)
