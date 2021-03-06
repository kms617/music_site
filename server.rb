require 'sinatra'
require 'csv'
require 'pry'

MUSIC_DATA = 'songs.csv'

def import_csv(filename)
  result = []
  CSV.foreach(filename, headers: true) do |row|
    result << row
  end
  result
end

helpers do
  def seconds_to_time(sec)
    minutes = sec / 60
    seconds = sec % 60
    "#{minutes}:#{seconds.to_s.rjust(2, '0')}"
  end
end

get '/' do
  @songs = import_csv(MUSIC_DATA)
  @albums = @songs.map { |song| "#{song['artist']} - #{song['album']}" }.uniq
  erb :albums
end

get '/:album' do
  @album = params['album']
  @songs = import_csv(MUSIC_DATA)
  @album_songs = @songs.select{ |song| song['album'] == @album }
  @artist = @album_songs[0]['artist']
  @year = @album_songs[0]['year']
  @genre = @album_songs[0]['genre']
  erb :album, layout: :layout
end
