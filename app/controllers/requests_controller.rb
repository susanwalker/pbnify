class RequestsController < ApplicationController
  def new
    @request = Request.new
  end

  def create
    new_request_params = params.permit(:authenticity_token, :commit, request: [:input_image])[:request]
    @request = Request.new(new_request_params)

    if @request.save
      PbnConverter.update(@request)
      redirect_to request_url(@request)
    else
      render 'new'
    end
  end

  def show
    id = params.fetch('id')
    @request = Request.find(id)
  end

  def download
  end
end
