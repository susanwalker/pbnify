class ApplicationController < ActionController::Base
   http_basic_authenticate_with name: ENV['USER'],
                                password: ENV['PASSWORD'],
                                except: :index
end
