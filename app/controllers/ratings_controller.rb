class RatingsController < ApplicationController
  def index
    # Getting up-to-date information in the cache is handled by UpdateTopJob, at /jobs/update_top_job.rb
    @best_beers = Rails.cache.read('best_beers')
    @best_breweries = Rails.cache.read('best_breweries')
    @best_styles = Rails.cache.read('best_styles')
    @recent_ratings = Rails.cache.read('best_ratings')
    @most_active_users = Rails.cache.read('most_active_users')
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
