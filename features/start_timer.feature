Feature: Record time
  As a user
  I want to record time
  So that I know how much time has passed

  Scenario: New user clicks start
    Given I have started Time Tracker for the first time
    When I start the timer
    Then the document should have one project
    And the first project should have one task
    And the active task should be the first task of the first project
    And the selected task should be the first task of the first project
