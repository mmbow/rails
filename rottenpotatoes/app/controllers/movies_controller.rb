# This file is app/controllers/movies_controller.rb
class MoviesController < ApplicationController

  def index
    @all_ratings = Movie.ratings

    # Remember the checked rantis
    if  params[:ratings].present?
        @checked_rating = params[:ratings].keys
        session[:ratings] = params[:ratings]
    else
      if session[:ratings].present?
         @checked_rating = session[:ratings].keys
      else
        @checked_rating = @all_ratings
      end
    end


    # Remembers if it was sorted or not
    if params[:sort].present?
      session[:sort] = params[:sort]

      if params[:sort]  == "title"
        @movies = Movie.where(rating: @checked_rating).sort_by(&:title)
      else
        @movies = Movie.where(rating: @checked_rating).sort_by(&:release_date)
      end
    else
      if session[:sort].present?
        flash.keep
        redirect_to movies_path(:sort => session[:sort], :rating => @checked_rating)
      else
        @movies = Movie.where(rating: @checked_rating)
      end
    end

    @movies
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # Look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
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

  def sort_by_name
     @movies = Movie.order('title')
  end

end
