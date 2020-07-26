require 'uri'
require 'net/http'
require 'openssl'
require 'json'
require 'pry'
require 'dotenv'
Dotenv.load
  
class MovieData

  def self.mov(user_input)
    input_url = URI("https://movie-database-imdb-alternative.p.rapidapi.com/?page=1&r=json&s=#{user_input}")

    http = Net::HTTP.new(input_url.host, input_url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  
    request = Net::HTTP::Get.new(input_url)
    request["x-rapidapi-host"] = 'movie-database-imdb-alternative.p.rapidapi.com'
    request["x-rapidapi-key"] = ENV['IMDB_API_KEY'].split("'")[0]

    response = http.request(request)
    data = JSON.pretty_generate(JSON.parse(response.body))
  
    res = JSON.parse(data)
    imdbid = res["Search"][0]["imdbID"]
    
    res_url = URI("https://movie-database-imdb-alternative.p.rapidapi.com/?i=#{imdbid}&r=json")
    http = Net::HTTP.new(res_url.host, res_url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    search_request = Net::HTTP::Get.new(res_url)
    search_request["x-rapidapi-host"] = 'movie-database-imdb-alternative.p.rapidapi.com'
    search_request["x-rapidapi-key"] = ENV['IMDB_API_KEY'].split("'")[0]


    search_response = http.request(search_request)
    search_result = JSON.pretty_generate(JSON.parse(search_response.body))

    result_data = JSON.parse(search_result)

    if result_data["Type"] == "movie"
      puts title = "Movie Title: #{result_data["Title"]}"
      puts year = "Release Year: #{result_data["Year"].to_i}"
      puts rating = "Rated: #{result_data["Rated"]}"
      puts runtime = "Runtime: #{result_data["Runtime"].split[0].to_i} minutes"
      puts genre = "Genre: #{result_data["Genre"]}"
      puts director = "Director: #{result_data["Director"]}"
      puts writer = "Writer: #{result_data["Writer"]}"
      puts actors = "Actors/Actresses: #{result_data["Actors"]}"
      puts plot = "Plot: #{result_data["Plot"]}"
      puts language = "Language: #{result_data["Language"]}"
      puts country = "Country: #{result_data["Country"]}"
      puts awards = "Awards: #{result_data["Awards"]}"
      puts poster_link = "Poster Link: #{result_data["Poster"]}"
      puts imdb_rating = "Imdb Rating: #{result_data["imdbRating"].to_f}"
      puts production = "Production: #{result_data["production"]}"
      puts link_to_imdb = "Link to IMDB: https://www.imdb.com/title/#{imdbid}/"
      Movie.create(
        imbdid: imdbid, 
        title: result_data["Title"], 
        year: result_data["Year"].to_i, 
        rated: result_data["Rated"], 
        runtime: result_data["Runtime"].split[0].to_i, 
        genre: result_data["Genre"], 
        director: result_data["Director"], 
        writer: result_data["Writer"], 
        actors: result_data["Actors"], 
        plot: result_data["Plot"], 
        language: result_data["Language"], 
        country: result_data["Country"], 
        awards: result_data["Awards"], 
        poster_link: result_data["Poster"], 
        imdb_rating: result_data["imdbRating"].to_f,
        production: result_data["production"])
    else
      puts "Sorry, this search is only for movies"
    end

  end
end