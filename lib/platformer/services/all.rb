def recursive_require_relative path
  Dir[File.expand_path("#{path}/**/*.rb", __dir__)].each do |f|
    require_relative f
  end
end

recursive_require_relative "."
