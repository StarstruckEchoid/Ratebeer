json.extract! brewery, :id, :name, :year
json.beers brewery.beers.count
json.status brewery.active? ? "active" : "retired"
