require 'rubygems'
require 'sinatra'
require 'uri'

set :bind, '0.0.0.0'

$music_file_dir = './playlist'

get '/' do
  playlist = Dir.glob File.join($music_file_dir, '*.{m3u,pls,mp3}')
  playlist = playlist.collect{|a| File.basename(a)}.sort
  erb :index, :locals => { :playlist => playlist }
end

get '/play' do
  `mocp -p`
  redirect to('/')
end

get '/pause' do
  `mocp -P`
  redirect to('/')
end

get '/playselect/:file' do
  file = params[:file]
  file_dir = File.join $music_file_dir, file
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