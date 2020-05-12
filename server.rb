require 'rubygems'
require 'sinatra'
require 'uri'
require 'redis'

set :bind, '0.0.0.0'

$MUSIC_FILE_DIR = './playlist'.freeze

redis = Redis.new(host: "localhost")

get '/' do
  playlist = Dir.glob File.join($MUSIC_FILE_DIR, '*.{m3u,pls,mp3}')
  playlist = playlist.collect{|a| URI.encode_www_form_component(File.basename(a))}.sort
  erb :index, locals: { playlist: playlist, status: redis.get("radioStatus"), selectedFile: redis.get("selectedFile") }
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
  file = URI.decode_www_form_component(params[:file])
  file_encode = URI.encode_www_form_component(file)
  file_dir = File.join $MUSIC_FILE_DIR, file
  redis.set("selectedFile", file_encode)
  redis.set("radioStatus", "play")
  `mocp -s`
  `mocp -c`
  `mocp -a "#{file_dir}"`
  `mocp -p`
  redirect to("/\##{file_encode}")
end

get '/volume_up' do
  `mocp -v +5`
  redirect to('/')
end

get '/volume_down' do
  `mocp -v -5`
  redirect to('/')
end