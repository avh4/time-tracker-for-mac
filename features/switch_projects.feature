Feature: Switch projects
  In order to not interrupt my work
  As a freelancer
  I want to easily switch the timer to a different project without leaving my current application

  Scenario: Using the menu bar dropdown
    Given I have recently used the task "Time Tracker : development"
    And the timer is running on task "Website X : design"
    When I choose "Time Tracker : development" from the menu bar dropdown
    Then "Time Tracker : development" should be the active task
  
