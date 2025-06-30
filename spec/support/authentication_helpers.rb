module AuthenticationHelpers
  def login_as(user)
    post login_path, params: {
      email: user.email,
      password: "Password1010-"
    }
  end

  def create_and_login_user
    user = FactoryBot.create(:user)
    login_as(user)
    user
  end
end
