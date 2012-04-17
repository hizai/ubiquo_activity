require File.dirname(__FILE__) + "/../../test_helper.rb"

class Ubiquo::ActivityInfosControllerTest < ActionController::TestCase
  use_ubiquo_fixtures
  
  def test_should_get_index
    activity_info = create_activity_info
    get :index
    assert_response :success
    assert_not_nil assigns(:activity_infos)
  end

  def test_should_get_index_filtered
    activity_info = create_activity_info
    activity_info2 = create_activity_info(:created_at => Time.now - 10.days)
    get :index, :filter_date_start => (activity_info.created_at -1.day).strftime("%d/%m/%Y")
    assert_equal 1, assigns(:activity_infos).size
    get :index, :filter_date_start => "20/10/#{Time.now.year+1}" # None starts on the future
    assert_equal 0, assigns(:activity_infos).size
    assert_response :success
    assert_not_nil assigns(:activity_infos)
  end
  
  def test_should_get_index_with_permission
    login_with_permission(:activity_info_management)
    get :index
    assert_response :success
    assert_not_nil assigns(:activity_infos)
  end

  def test_should_not_get_index_without_permission
    login_with_permission
    get :index
    assert_response :forbidden
  end  
  
  private
  
    def test_should_get_index_with_permission
    login_with_permission(:activity_info_management)
    get :index
    assert_response :success
    assert_not_nil assigns(:activity_infos)
  end

  def test_should_not_get_index_without_permission
    login_with_permission

    get :index
    assert_response :forbidden
  end  
  
  private

  def create_activity_info(options = { })
    user = create_ubiquo_user
    default_options = {
      :controller => "tests_controller",
      :action => "create",
      :status => "successful",
      :ubiquo_user_id => user.id,
      :related_object => UbiquoUser.first,
    }
    ActivityInfo.create(default_options.merge(options))
  end
  
  def create_ubiquo_user(options = {})
    UbiquoUser.create({
        :name => "name",
        :surname => "surname",
        :login => 'quire', 
        :email => "quire@quire.com", 
        :password => 'quire', 
        :password_confirmation => 'quire' 
      }.merge(options))
  end
  
end
