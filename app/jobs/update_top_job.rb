class UpdateTopJob
  include SuckerPunch::Job

  def perform
    Rails.cache.write('best_beers', Beer.includes(:brewery, :ratings).best)
    Rails.cache.write('best_breweries', Brewery.includes(:ratings).best)
    Rails.cache.write('best_styles', Style.includes(:ratings).best)
    Rails.cache.write('best_ratings', Rating.includes(:beer, :user).recent)
    Rails.cache.write('most_active_users', User.includes(:ratings).most_active)

    UpdateTopJob.perform_in(1.hour)
  end
end
