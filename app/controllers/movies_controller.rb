class MoviesController < ApplicationController
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    session_ratings = (session[:ratings] == nil) ? @all_ratings : (JSON.parse session[:ratings])
    @ratings = params[:ratings]
    @ratings = (@ratings == nil) ? session_ratings        : @ratings.keys
    session_sort = (session[:sort] == nil) ? ""           : session[:sort]
    session_sort = (params [:sort] == nil) ? session_sort : params[:sort]
    session[:ratings] = JSON.generate @ratings
    session[:sort]    = session_sort
    @movies = (Movie.where rating: @ratings).order session_sort
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    params.permit!
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
