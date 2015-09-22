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

    redirect = false

    if (not params[:order_by]) and session[:order_by]
      params[:order_by] = session[:order_by]
      redirect = true
    end

    if params[:commit] != "Refresh" and session[:commit]
      params[:commit] = session[:commit]
      redirect = true
    end

    if (not params[:ratings]) and session[:ratings]
      params[:ratings] = session[:ratings]
      redirect = true
    end



    if redirect
      flash.keep
      new_params = Hash[:order_by => params[:order_by], :commit => params[:commit], :ratings => params[:ratings]]
      redirect_to movies_path(new_params)

    else
      session[:commit] = params[:commit]
      session[:ratings] = params[:ratings]
      session[:order_by] = params[:order_by]

      @para = Hash.new
      @para[:all_ratings] = %w[G PG PG-13 NC-17 R]
      @para[:selected_ratings] = []
      @para[:order_by] = params[:order_by]

      if params[:commit] == "Refresh" and params[:ratings]
          @para[:all_ratings].each {|r| @para[:selected_ratings] << r if params[:ratings][r]}
          @movies = Movie.ratings_include(@para[:selected_ratings])
      else
        @movies = Movie.all
      end

      if params[:order_by] == "title"
        @movies = @movies.order(:title)
      elsif params[:order_by] == "release_date"
        @movies = @movies.order(:release_date)
      end
    end
  end

  # def title_ordered
  #   redirect_to movies_path(title_ordered: true)
  # end

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
