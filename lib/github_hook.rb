require "sinatra/base"
require "json"
require "time"

class GithubHook < Sinatra::Base
  def self.parse_git
    # Parse hash and date from the git log command.
    puts "I am running parse_git:"
    sha1, date = `git log HEAD~1..HEAD --pretty=format:%h^%ci`.strip.split('^')

    puts "commit_hash = #{sha1}"
    puts "commit_date = #{Time.parse(date)}"
    set :commit_hash, sha1
    set :commit_date, Time.parse(date)
  end

  set(:autopull) { production? }
  parse_git

  before do
    cache_control :public, :must_revalidate
    etag settings.commit_hash
    last_modified settings.commit_date
  end

  post '/update' do
    push = JSON.parse(params[:payload])
    puts "I got some JSON: #{push.inspect}"

    cmd_output = "ok"
    if settings.autopull?
      # Pipe stderr to stdout to make sure we display everything
      puts "\nTrying to `git pull 2>&1` ..."
      cmd_output = `git pull 2>&1`
      puts "`git pull 2>&1` reports:\n#{cmd_output}"
    end

    settings.parse_git

    app.settings.reset!
    load app.settings.app_file
    
    content_type :txt
    cmd_output
  end
end
