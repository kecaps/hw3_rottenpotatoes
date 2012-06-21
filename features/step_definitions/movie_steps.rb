# Add a declarative step here for populating the DB with movies.


class Hash
  def replace_values!(*keys)
    keys.each do |k|
      if has_key?(k) then
        self[k] = yield self[k]
      end
    end
    self
  end
end

module MovieHelpers
  COLUMN_NAME_TO_FIELD_NAMES = { "Movie Title" => "title",
                                 "Rating" => "rating",
                                 "Release Date" => "release_date" }
  def movies_in_table
    rows = find("table#movies").all("tr")
    field_names = rows.shift.all('th').first(3).map { |c| COLUMN_NAME_TO_FIELD_NAMES[c.text.strip] }
    return rows.map do |r| 
      tds = r.all('td').map { |c| c.text.strip }
      movie = Hash[field_names.map { |f| [f, tds.shift] }].replace_values!("release_date") { |d| d.to_date }
    end
  end
end
World(MovieHelpers)

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create(movie)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  movies = movies_in_table().map { |m| m["title"] }
  movies.index(e1).should < movies.index(e2)
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"
When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  rating_list.split(',').each do |rating|
    rating.strip!
    step %Q{I #{uncheck}check "ratings_#{rating}"}
  end
end

Then /the following ratings should be (un)?checked: (.*)/ do |uncheck, rating_list|
  rating_list.split(',').each do |rating|
    rating.strip!
    step %Q{the "ratings_#{rating}" checkbox should #{uncheck ? "not " : "" }be checked}
  end
end

Then /I should see the following movies:/ do |expected_movies|
  movies = movies_in_table()
  expected_movies.hashes.each do |movie|
    movie.replace_values!("release_date") { |d| d.to_date }
    movies.should include(movie) 
  end
end

Then /I should not see the following movies:/ do |expected_movies|
  movies = movies_in_table()
  expected_movies.hashes.each do |movie|
    movie.replace_values!("release_date") { |d| d.to_date }
    movies.should_not include(movie) 
  end
end

Then /I should see all of the movies/ do
  all_movies = Movie.find(:all)
  movies = movies_in_table()
  all_movies.size.should  == movies.size
  all_movies.each do |movie|
    movies.should include(Hash[MovieHelpers::COLUMN_NAME_TO_FIELD_NAMES.values.map { |k| [ k, movie[k]]}].replace_values!("release_date") { |d| d.to_date}) 
  end
end  

Then /I should see no movies/ do
  movies_in_table().size().should == 0
end  

Then /movies should be sorted by "(.*)"/ do |col|
  field = MovieHelpers::COLUMN_NAME_TO_FIELD_NAMES[col]
  movies = movies_in_table()
  last_value = movies.shift[field]
  movies.each do |movie|
    value = movie[field]
    last_value.should < value
    last_value = value
  end
end
       
Then /^the director of "([^"]*)" should be "([^"]*)"$/ do |movie, director|
  Movie.find_by_title(movie).director.should == director
end

   
