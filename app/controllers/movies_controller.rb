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
    @all_ratings = Movie.all_ratings
    @sort = params[:sort]
    @ratings = params[:ratings]
    @selected_ratings = @all_ratings
    redirect = false
    if params[:sort].nil? == false 
      session[:sort] = params[:sort]
    elsif session[:sort].nil? == false
      @sort = session[:sort]
      redirect = true
    else
      @sort = nil
    end

    if @ratings.nil? == false
      session[:ratings] = params[:ratings]
    elsif session[:ratings].nil? == false 
      @ratings = session[:ratings]
      redirect = true
    else
      @ratings = nil
    end

    if redirect
      flash.keep
      redirect_to movies_path :sort => @sort, :ratings => @ratings
    end


    if @ratings.nil? == false and @sort.nil? == false
       @selected_ratings = @ratings.keys
       @movies = Movie.order(@sort).where(:rating => @ratings.keys)
    elsif @ratings.nil? == false and @sort.nil?
       @selected_ratings = @ratings.keys
       @movies = Movie.where(:rating => @ratings.keys)
    elsif @ratings.nil? and @sort.nil? == false 
       @movies = Movie.order(@sort)
    else
      @movies = Movie.all
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




# class MoviesController < ApplicationController

#   def movie_params
#     params.require(:movie).permit(:title, :rating, :description, :release_date)
#   end

#   def show
#     id = params[:id] # retrieve movie ID from URI route
#     @movie = Movie.find(id) # look up movie by unique ID
#     # will render app/views/movies/show.<extension> by default
#   end

#   def index
#     @all_ratings = Movie.all_ratings
#     @movies = Movie.all
#     @sort = params[:sort]
#     @ratings = params[:ratings]
#     @selected_ratings = @all_ratings
    
#     if @ratings.nil?
#       @movies = Movie.order(@sort)
#     else
#       @selected_ratings = @ratings.keys
#       @movies = Movie.order(@sort).where(:rating => @ratings.keys)
     
#     end
    
#   end

#   def new
#     # default: render 'new' template
#   end

#   def create
#     @movie = Movie.create!(movie_params)
#     flash[:notice] = "#{@movie.title} was successfully created."
#     redirect_to movies_path
#   end

#   def edit
#     @movie = Movie.find params[:id]
#   end

#   def update
#     @movie = Movie.find params[:id]
#     @movie.update_attributes!(movie_params)
#     flash[:notice] = "#{@movie.title} was successfully updated."
#     redirect_to movie_path(@movie)
#   end

#   def destroy
#     @movie = Movie.find(params[:id])
#     @movie.destroy
#     flash[:notice] = "Movie '#{@movie.title}' deleted."
#     redirect_to movies_path
#   end

# end
