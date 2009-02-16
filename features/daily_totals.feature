Feature: View daily totals
  As a consultant
  I want to view daily totals
  So that I can bill my clients accurately and easily

  Scenario: View today's totals
    Given I have recorded my data in Time Tracker
    When I set the filter to "Today"
    Then I will see today's totals for all projects
    And I will see today's totals for all tasks
    And I will only see today's work periods
	