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
    if params[:clear_session] == "true"
      reset_session
    end
    @valid_ratings= Movie.valid_ratings
    @ratings_filter= params[:ratings_filter] || []
    if @ratings_filter.length == 0
      flash.keep
      # Make sure we save sort change
      redirect_to movies_path(
        :ratings_filter => session[:ratings_filter] || @valid_ratings,
        :sort => params[:sort] || session[:sort] || "none"
      )
    end
    session[:ratings_filter]= @ratings_filter

    if params[:sort] == "title"
      @movies = Movie.order('movies.title ASC').with_ratings(@ratings_filter)
      @sort= "title"
      session[:sort]= "title"
    elsif params[:sort] == "release_date"
      @movies = Movie.order('movies.release_date ASC').with_ratings(@ratings_filter)
      @sort= "release_date"
      session[:sort]= "release_date"
    else
      @movies = Movie.all.with_ratings(@ratings_filter)
      @sort= session[:sort] || "none"
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
