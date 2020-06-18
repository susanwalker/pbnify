class ApplicationController < ActionController::Base
  unless Rails.env.test?
    http_basic_authenticate_with name: ENV['USER'],
                                 password: ENV['PASSWORD'],
                                 except: :index
  end

  before_action :delete_old_requests

  # Deletes requests created 15 minutes before now
  # TODO: Add a spec for this
  def delete_old_requests
    Request.where('created_at < ?', Time.now - 15.minutes).delete_all
  end
end
