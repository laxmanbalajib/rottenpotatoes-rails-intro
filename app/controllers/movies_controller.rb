class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @all_ratings = Movie.movie_ratings
    do_redirect = 0
    
    if params[:ratings]
      session[:ratings] = params[:ratings]
    elsif session[:ratings]
       do_redirect = 1
    end
    
    if params[:sort_by]
      session[:sort_by] = params[:sort_by]
    elsif session[:sort_by]
      do_redirect = 1
    end
    
    unless session[:ratings]
      session[:ratings] = Hash[@all_ratings.map{|x| [x, x]}]
    end
    
    @sortBy = session[:sort_by]
    @ratingsSelected = session[:ratings].keys

    @movies = @movies.order(@sortBy)
    @movies = @movies.where(rating: @ratingsSelected)
    
    if do_redirect == 1
      flash.keep
      redirect_to movies_path(sort_by: session[:sort_by] , ratings: session[:ratings])
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
