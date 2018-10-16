class RatingsController < ApplicationController
  def index
    @ratings = Rating.all
    @recent_ratings = Rating.includes(:beer, :user).recent
    @best_beers = Beer.includes(:brewery).best
    @best_breweries = Brewery.best
    @best_styles = Style.best
    @most_active_users = User.includes(:ratings).most_active
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    @rating = Rating.new params.require(:rating).permit(:score, :beer_id)
    @rating.user = current_user

    if @rating.save
      redirect_to current_user
    else
      @beers = Beer.all
      render :new
    end
  end

  def destroy
    rating = Rating.find(params[:id])
    rating.delete if current_user == rating.user
    redirect_to current_user
  end
end
