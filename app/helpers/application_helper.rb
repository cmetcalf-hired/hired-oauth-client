module ApplicationHelper
  def login_link
    link_to 'Login', new_user_session_path
  end

  def logout_link
    link_to 'Logout', destroy_user_session_path, method: 'delete'
  end
end
