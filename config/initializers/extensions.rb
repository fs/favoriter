# Require recursively all files in the lib/extensions
Dir[Rails.root.join('lib/**/extensions/**/*.rb')].each {|f| require f}