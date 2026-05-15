require File.expand_path(File.dirname(__FILE__) + '/../../../test/test_helper')

# Custom helper methods can be defined here
module SubskillsTestHelper
  def create_user(login, admin=false)
    User.create!(
      login: login,
      firstname: login.capitalize,
      lastname: 'User',
      mail: "#{login}@example.com",
      admin: admin
    )
  end
end
