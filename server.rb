require 'rubygems'
require 'sinatra'
require 'uri'
require 'redis'

set :bind, '0.0.0.0'

$music_file_dir = './playlist'

redis = Redis.new(host: "localhost")

get '/' do
  playlist = Dir.glob File.join($music_file_dir, '*.{m3u,pls,mp3}')
  playlist = playlist.collect{|a| File.basename(a)}.sort
  erb :index, :locals => { :playlist => playlist, :status => redis.get("radioStatus"), :selectedFile => redis.get("selectedFile") }
end

get '/play' do
  `mocp -p`
  redis.set("radioStatus", "play")
  redirect to('/')
end

get '/pause' do
  `mocp -P`
  redis.set("radioStatus", "pause")
  redirect to('/')
end

get '/playselect/:file' do
  file = params[:file]
  file_dir = File.join $music_file_dir, file
  redis.set("selectedFile", file)
  redis.set("radioStatus", "play")
  `mocp -s`
  `mocp -c`
  `mocp -a "#{file_dir}"`
  `mocp -p`
  redirect to("/\##{URI.escape file}")
end

get '/volume_up' do
  `mocp -v +5`
  redirect to('/')
end

get '/volume_down' do
  `mocp -v -5`
  redirect to('/')
end