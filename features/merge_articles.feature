Feature: Merge Articles
    As a blog administrator
    In order to remove duplicated articles
    I want to be able to merge articles with same topic

    Background: articles and users have been added to database

        Given the blog is set up

        Given the following users exist:
            | profile_id | login | name  | password | email            | state  |
            | 2          | user1 | User1 | 12345678 | none@example.com | active |
            | 3          | user2 | User2 | 12345678 | not@example.com  | active |

        Given the following articles exist:
            | id | title    | author | user_id | body     | allow_comments | published | published_at        | state     | type    |
            | 3  | Article1 | user1  | 2       | Content1 | true           | true      | 2014-28-11 14:05:00 | published | Article |
            | 4  | Article2 | user2  | 3       | Content2 | true           | true      | 2014-28-11 14:06:00 | published | Article |

        Given the following comments exist:
            | id | type    | author | body     | article_id | user_id | created_at          |
            | 1  | Comment | user1  | Comment1 | 3          | 2       | 2014-28-11 14:10:00 |
            | 2  | Comment | user1  | Comment2 | 4          | 2       | 2014-28-11 14:20:00 |

    Scenario: A non-admin cannot merge articles
        Given I am logged in as "user1" with pass "12345678"
        And I am on the Edit Page of Article with id 3
        Then I should not see "Merge Articles"

    Scenario: An admin can merge articles
        Given I am logged in as "admin" with pass "password"
        And I am on the Edit Page of Article with id 3
        Then I should see "Merge Articles"
        When I fill in "merge_with" with "4"
        And I press "Merge"
        Then I should be on the admin content page
        And I should see "Articles successfully merged!"

    Scenario: The merged articles should contain the text of both previous articles
        Given the articles with ids "3" and "4" were merged
        And I am on the home page
        Then I should see "Article1"
        When I follow "Article1"
        Then I should see "Content1"
        And I should see "Content2"

    Scenario: The merged article should have one author (either one of the originals)
        Given the articles with ids "3" and "4" were merged
        Then "User1" should be author of 1 articles
        And "User2" should be author of 0 articles

    Scenario: Comments on each of the two articles need to all be carried over
        Given the articles with ids "3" and "4" were merged
        And I am on the home page
        Then I should see "Article1"
        When I follow "Article1"
        Then I should see "Comment1"
        And I should see "Comment2"

    Scenario: The title should be either one of the merged articles
        Given the articles with ids "3" and "4" were merged
        And I am on the home page
        Then I should see "Article1"
        And I should not see "Article2"
