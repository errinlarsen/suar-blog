require "sinatra/base"
require "github_hook"
require "ostruct"
require "time"
require "haml"

class Blog < Sinatra::Base
  use GithubHook

  set :root, File.expand_path("../../", __FILE__)
  set :articles, []
  set :app_file, __FILE__

  Dir.glob "#{root}/articles/*.md" do |file|
    meta, content = File.read(file).split("\n\n", 2)
    article = OpenStruct.new YAML.load(meta)
    article.date = Time.parse article.date.to_s
    article.content = content
    
    article.slug = File.basename(file, ".md")

    summary = content.split("\n").first(10)
    article.has_more = true if summary.size >= 10
    article.summary = summary.join("\n")

    get "/#{article.slug}" do
      haml :post, :locals => { article: article }
    end

    articles << article
  end

  # Sort articles by date, display new articles first
  articles.sort_by! { |article| article.date }
  articles.reverse!

  get "/" do
    haml :index
  end
end
