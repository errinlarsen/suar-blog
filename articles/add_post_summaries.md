title: Post summaries
date: 2012-01-15 6:55am

In an attempt to tidy the blog up a bit, I modified the code a little to only
show summaries on the index page.  This way, if I post an article that has more
than ten lines, the blog will auto-summarize it to 10 lines for the index and
generate a "Read more ..." link at the bottom of the summary.  It was pretty
easy to do.

Here is a bit of the relevant code before I made any changes:

    _
    class Blog < Sinatra::Base
      # ... Code removed for brevity
        article = OpenStruct.new YAML.load(meta)
        article.date = Time.parse article.date.to_s
        article.content = content
        article.slug = File.basename(file, ".md")

        get "/#{article.slug}" do
          haml :post, :locals => { article: article }
        end

        articles << article
      # ... more code removed
    end

I added an article.summary attribute:

    _
    class Blog < Sinatra::Base
      # ... Code remove for brevity
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
      # ... more code removed
    end

Here is the relevant view code, a new post_summary.haml template, that
generates the "Read more ..." link, if it needs to:

    _
    %article
      %header
        %h1
          %a{ href: url(article.slug) }
            = article.title
          %time.timeago{ datetime: article.date.xmlschema }
            = article.date.strftime "%Y/%m/%d"
      %section.content
        = markdown article.summary
        - if article.has_more
          %a{ href: url(article.slug) } Read more ...

Pretty simple.  Quick change - and now the blog looks a little nicer.
