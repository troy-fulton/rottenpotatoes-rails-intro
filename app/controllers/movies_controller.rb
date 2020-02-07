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
    # Populate the ratings at the top with unique ratings
    # if it's the first time doing so
    all_ratings_movies = Movie.select(:rating).distinct
    @all_ratings = all_ratings_movies.map do |m| m.rating end.sort
    
    # See if the user clicked the refresh button to filter by rating
    refresh_clicked = (params.has_key? :commit) && (params[:commit] == "Refresh")
    
    # Start up a hash with all these ratings and populate it with either
    # all selected (before clicking refresh) or with user-selected checkboxes
    @ratings_selected = Hash.new
    logger.debug(params[:ratings])
    for rating in @all_ratings
      if refresh_clicked
        # (i) See which boxes the user picked
        @ratings_selected[rating] = params[:ratings].has_key?(rating)
      else
        @ratings_selected[rating] = true
      end
    end
    
    # (ii) Filter using the method from the model class
    filtered_ratings = @ratings_selected.select{|k,v| v}.keys
    @movies = Movie.with_ratings(filtered_ratings)
    
    # Then sort the movies (if it needs to be done)
    case params[:sort_by]
    when "title"
      @movies = @movies.order(:title)
      @title_header_css_class = "hilite"
    when "rating"
      @movies = @movies.order(:rating)
      @rating_header_css_class = "hilite"
    when "release_date"
      @movies = @movies.order(:release_date)
      @release_date_header_css_class = "hilite"
    end
  end
  
  def sort
    redirect_to movies_path(:sort_by =>params[:sort_by])
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
