class InitBreweryActivityToTrue < ActiveRecord::Migration[5.2]
  def up
    Brewery.all.each{ |b| b.update(active: true) }
  end

  def down
    Brewery.all.each{ |b| b.update(active: nil) }
  end
end
