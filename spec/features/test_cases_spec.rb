feature 'A feature with test cases' do

  scenario_with_test_cases 'A scenario requiring multiple cases to prove' do
    test_case 'a passing test case' do
      fail('the first test case failed')
    end

    test_case 'a failing test case' do
      fail('the second test case also also failed')
    end
  end

end