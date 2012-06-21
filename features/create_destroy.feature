Feature: create and destroy movies

  As a movie buff
  So that I can manage the set of movies in the database
  I want to be able to create and destroy movies

Background: movies in database

  Given the following movies exist:
  | title        | rating | director     | release_date |
  | Star Wars    | PG     | George Lucas |   1977-05-25 |
  | Blade Runner | PG     | Ridley Scott |   1982-06-25 |
  | Alien        | R      |              |   1979-05-25 |
  | THX-1138     | R      | George Lucas |   1971-03-11 |


Scenario: create new movie
  Given I am on the RottenPotatoes home page
  When  I check the following ratings: G
  And   I uncheck the following ratings: PG, PG-13, R, NC-17
  And   I press "Refresh"
  Then  I should see no movies
  When  I follow "Add new movie"
  Then  I should be on the new movie page
  When  I fill in the following:
    |Title    | Toy Story 3   |
    |Director | John Lasseter |
  And   I select "G" from "Rating"
  And   I select "2010" from "movie_release_date_1i"
  And   I select "June" from "movie_release_date_2i"
  And   I select "18" from "movie_release_date_3i"
  And   I press "Save Changes"
  Then  I should be on the RottenPotatoes home page
  And   I should see "Toy Story 3 was successfully created"
  And   I should see the following movies:
  | title        | rating | director     | release_date |
  | Toy Story 3  | G      | John Lasseter|   2010-06-18 |
  
