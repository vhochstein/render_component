source "http://rubygems.org"

# Bundler 1.x default to insecure http:// for github: shortcut
git_source(:github){ |repo_name| "https://github.com/#{repo_name}.git" }

gemspec :path => ".."

gem "activerecord", "~> 6.0.0"
