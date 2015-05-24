# Add a declarative step here for populating the DB with movies.

Given /^the following movies exist:$/ do |movies_table|
  movies_table.hashes.each do |movie|
    puts movie
    Movie.create!(movie)
  end
end


# Scenario I and II
When /I check the following ratings: (.*)/ do |rating_list|
  rating_list.split(", ").each do |rating|
      check("ratings[#{rating}]")
  end
end

# Scenario I and II
When /I uncheck the following ratings: (.*)/ do |rating_list|
  rating_list.split(", ").each do |rating| 
        uncheck("ratings[#{rating}]")
  end
end

# Scenario I and II
Then /I should see all the movies: (.*)/ do |movies_list|
  movies_list.split(", ").each do |movie|
    assert page.has_content?(movie)
  end
end

Then /I should not see all the movies: (.*?)/ do |movies_list|
  movies_list.split(", ").each do |movie|
    assert not(page.has_content?(movie))
  end
end

#Sort Movie List
Then /I should see "(.*?)" before "(.*?)"/ do |e1, e2|
  assert page.body.index(e1) < page.body.index(e2)
end

