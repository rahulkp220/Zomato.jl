__precompile__(true)

module Zomato

# External Imports
import HTTP
import JSON

# Module Exports
export categories, cities, collections, cuisines, establishments, geocode
export locations, location_details
export restaurant, reviews, search


"""
Zomato Z struct
"""
struct Z
	api_key::String
	base_url::String 

	Z(api_key,base_url="https://developers.zomato.com/api/v2.1/")=new(api_key, base_url)
end

Base.show(io::IO, z::Z) = print(io, "Zomato(", z.base_url, ')')


"""
Get list of categories
---------------------
List of all restaurants categorized under a particular restaurant type can be obtained using /Search API with Category ID as inputs

See https://developers.zomato.com/documentation#!/common/categories

Model Schema
------------
``` 
[
  {
    "category_id": "3",
    "category_name": "Nightlife"
  }
]
```
"""
function categories(z::Z)
	helper(z, "categories", Dict())
end


"""
Get city details
----------------
Find the Zomato ID and other details for a city . You can obtain the Zomato City ID in one of the following ways:

- City Name in the Search Query - Returns list of cities matching the query
- Using coordinates - Identifies the city details based on the coordinates of any location inside a city

If you already know the Zomato City ID, this API can be used to get other details of the city.

See https://developers.zomato.com/documentation#!/common/cities

Model Schema
------------
```
[
  {
    "id": "280",
    "name": "New York City, NY",
    "country_id": "216",
    "country_name": "United States",
    "is_state": "0",
    "state_id": "103",
    "state_name": "New York State",
    "state_code": "NY"
  }
]
```
Arguments
---------

| Parameter | Description                      | Parameter Type | Data Type |
|-----------|----------------------------------|----------------|-----------|
| q         | query by city name               | query          | String    |
| lat       | latitude                         | query          | Float     |
| lon       | longitude                        | query          | Float     |
| city_ids  | comma separated city_id values   | query          | String    |
| count     | number of max results to display | query          | Int       |
"""
function cities(z::Z; kwargs...)
	helper(z, "cities", Dict(kwargs))
end


"""
Get zomato collections in a city
--------------------------------
Returns Zomato Restaurant Collections in a City. The location/City input can be provided in the following ways -

- Using Zomato City ID
- Using coordinates of any location within a city

List of all restaurants listed in any particular Zomato Collection can be obtained using the '/search' API with Collection ID and Zomato City ID as the input

See https://developers.zomato.com/documentation#!/common/collections

Model Schema
-----------
```
[
  {
    "collection_id": "1",
    "title": "Trending this week",
    "url": "https://www.zomato.com/new-york-city/top-restaurants",
    "description": "The most popular restaurants in town this week",
    "image_url": "https://b.zmtcdn.com/data/collections/e40960514831cb9b74c552d69eceee0f_1418387628_l.jpg",
    "res_count": "30",
    "share_url": "http://www.zoma.to/c-280/1"
  }
]
```

Arguments
---------

| Parameter | Description                                     | Parameter Type | Data Type |
|-----------|-------------------------------------------------|----------------|-----------|
| city_id   | id of the city for which collections are needed | query          | Int       |
| lat       | latitude                                        | query          | Float     |
| lon       | longitude                                       | query          | Float     |
| count     | number of max results to display                | query          | Int       |
"""
function collections(z::Z; kwargs...)
	helper(z, "collections", Dict(kwargs))
end


"""
Get list of all cuisines in a city

See https://developers.zomato.com/documentation#!/common/cuisines
"""
function cuisines(z::Z; kwargs...)
	helper(z, "cuisines", Dict(kwargs))
end


"""
Get list of restaurant types in a city

See https://developers.zomato.com/documentation#!/common/establishments
"""
function establishments(z::Z; kwargs...)
	helper(z, "establishments", Dict(kwargs))
end


"""
Get location details based on coordinates

See https://developers.zomato.com/documentation#!/common/geocode
"""
function geocode(z::Z; kwargs...)
	helper(z, "geocode", Dict(kwargs))
end


"""
Get zomato location details

See https://developers.zomato.com/documentation#!/location/location_details
"""
function location_details(z::Z; kwargs...)
	helper(z, "location_details", Dict(kwargs))
end


"""
Search for locations

See https://developers.zomato.com/documentation#!/location/locations
"""
function locations(z::Z; kwargs...)
	helper(z, "locations", Dict(kwargs))
end


"""
Get daily menu of a restaurant

See https://developers.zomato.com/documentation#!/restaurant/restaurant
"""
function dailymenu(z::Z; kwargs...)
	helper(z, "dailymenu", Dict(kwargs))
end


"""
Get restaurant details

See https://developers.zomato.com/documentation#!/restaurant/restaurant_0
"""
function restaurant(z::Z; kwargs...)
	helper(z, "restaurant", Dict(kwargs))
end


"""
Get restaurant reviews

See https://developers.zomato.com/documentation#!/restaurant/reviews
"""
function reviews(z::Z; kwargs...)
	helper(z, "reviews", Dict(kwargs))
end


"""
Get restaurant reviews

See https://developers.zomato.com/documentation#!/restaurant/search
"""
function search(z::Z; kwargs...)
	helper(z, "search", Dict(kwargs))
end


"""
HTTP Helper
"""
function helper(z::Z, func::String, d::Dict)
	header = Dict("Accept" => "application/json", "user-key"=> z.api_key)
	try
		query = query_builder(d)
		response = HTTP.get(z.base_url * "$func?" * query, header)
		return JSON.parse(String(response.body))
	catch 
		Dict()
	end
end


"""
Query Builder
"""
function query_builder(kwargs::Dict)
	query = ""
	for item in kwargs
		query *= "&$(item[1])=" * string(item[2])
	end
	return query
end


end # module