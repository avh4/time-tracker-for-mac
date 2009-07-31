Feature: Record time
  As a user
  I want to record time
  So that I know how much time has passed
  
  Scenario: Tracking time
    Given Time Tracker is newly installed
    When I start the timer
    And then I wait for 10 minutes to pass
    And then I stop the timer
    Then I should see a total time of 10 minutes
  
  # XXX This is an old feature and will be replaced by new, better-written features
  Scenario: New user clicks start
    Given I have started Time Tracker for the first time
    When I start the timer
    Then the document should have one project
    And the first project should have one task
    And the active task should be the first task of the first project
    And the selected task should be the first task of the first project
