require 'rack-flash'

class SongsController < ApplicationController
  use Rack::Flash

  get '/songs' do
    @songs = Song.all.sort_by {|song| song.name}
    erb :'/songs/index'
  end

  get '/songs/new' do
    @genres = Genre.all
    erb :'songs/new'
  end

  post '/songs' do
    # binding.pry
    song = Song.create(params[:song])
    song.artist = Artist.find_or_create_by(params[:artist])
    song.genre_ids = params[:genres]
    song.save

    flash[:message] = "Successfully created song."

    redirect to("/songs/#{song.slug}")
  end

  get '/songs/:slug/edit' do
    @song = Song.find_by_slug(params[:slug])
    erb :'songs/edit'
  end

  patch '/songs/:slug' do
   @song = Song.find_by_slug(params[:slug])
   @song.update(params[:song])
   @song.artist = Artist.find_or_create_by(name: params[:artist][:name])
   @song.genre_ids = params[:genres]
   @song.save

   flash[:message] = "Successfully updated song."
   redirect("/songs/#{@song.slug}")
 end

  get '/songs/:slug' do
    @song = Song.find_by_slug(params[:slug])
    erb :'songs/show'
  end
end
