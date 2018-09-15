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

See https://developers.zomato.com/documentation#!/common/categories
"""
function categories(z::Z)
	helper(z, "categories", Dict())
end


"""
Get city details

See https://developers.zomato.com/documentation#!/common/cities
"""
function cities(z::Z; kwargs...)
	helper(z, "cities", Dict(kwargs))
end


"""
Get zomato collections in a city

See https://developers.zomato.com/documentation#!/common/collections
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