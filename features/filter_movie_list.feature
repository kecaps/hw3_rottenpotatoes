Feature: display list of movies filtered by MPAA rating
 
  As a concerned parent
  So that I can quickly browse movies appropriate for my family
  I want to see movies matching only certain MPAA ratings

Background: movies have been added to database

  Given the following movies exist:
  | title                   | rating | release_date |
  | Aladdin                 | G      | 25-Nov-1992  |
  | The Terminator          | R      | 26-Oct-1984  |
  | When Harry Met Sally    | R      | 21-Jul-1989  |
  | The Help                | PG-13  | 10-Aug-2011  |
  | Chocolat                | PG-13  | 5-Jan-2001   |
  | Amelie                  | R      | 25-Apr-2001  |
  | 2001: A Space Odyssey   | G      | 6-Apr-1968   |
  | The Incredibles         | PG     | 5-Nov-2004   |
  | Raiders of the Lost Ark | PG     | 12-Jun-1981  |
  | Chicken Run             | G      | 21-Jun-2000  |

  And  I am on the RottenPotatoes home page
  
Scenario: restrict to movies with 'PG' or 'R' ratings
  When I check the following ratings: PG, R
  And I uncheck the following ratings: G, PG-13, NC-17
  And I press "Refresh"

  Then the following ratings should be checked: PG, R
  And the following ratings should be unchecked: G, PG-13, NC-17
  And I should see the following movies:
  | title                   | rating | release_date |
  | The Terminator          | R      | 26-Oct-1984  |
  | When Harry Met Sally    | R      | 21-Jul-1989  |
  | Amelie                  | R      | 25-Apr-2001  |
  | The Incredibles         | PG     | 5-Nov-2004   |
  | Raiders of the Lost Ark | PG     | 12-Jun-1981  |
  
  And I should not see the following movies:
  | title                   | rating | release_date |
  | Chicken Run             | G      | 21-Jun-2000  |
  | 2001: A Space Odyssey   | G      | 6-Apr-1968   |
  | Aladdin                 | G      | 25-Nov-1992  |
  | The Help                | PG-13  | 10-Aug-2011  |
  | Chocolat                | PG-13  | 5-Jan-2001   |

Scenario: no ratings selected
  When I uncheck the following ratings: G, PG, PG-13, R, NC-17
  And I press "Refresh"
  
  Then the following ratings should be unchecked: G, PG, PG-13, R, NC-17
  And I should see no movies

Scenario: all ratings selected
  When I check the following ratings: G, PG, PG-13, R, NC-17
  And I press "Refresh"

  Then the following ratings should be checked: G, PG, PG-13, R, NC-17
  And I should see all of the movies
