Slim::Engine.set_default_options format: :html5

PAGES = %w(cli configuration examples installation usage)

PAGES.each do |page|
  proxy page, "#{page}.html"
end

###
# Deploy
###

commit_sha = `git log --pretty="%h" -n1`.strip
commit_message = "update to #{commit_sha}"

activate :deploy do |deploy|
  deploy.build_before = true
  deploy.method = :git
  deploy.commit_message = commit_message
end

# Automatic image dimensions on image_tag helper
activate :automatic_image_sizes

# Reload the browser automatically whenever files change
configure :development do
  activate :livereload

  Slim::Engine.set_default_options pretty: true
end

###
# Helpers
###

helpers do
  def link_to_get_started
    link_to 'Get Started', 'installation', relative: true, class: 'btn btn-primary btn-block'
  end
end

set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'

# Build-specific configuration
configure :build do
  PAGES.map {|p| ignore p }

  # For example, change the Compass output style for deployment
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript

  # Enable cache buster
  activate :asset_hash

  # Use relative URLs
  activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/Content/images/"
end
