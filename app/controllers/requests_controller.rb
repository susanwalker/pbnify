class RequestsController < ApplicationController
  def new
    @request = Request.new
  end

  def create
    # permit is used to whitelist the params that you expect to get from the UI
    new_request_params =
      params.permit(
        :authenticity_token,
        :commit,
        request: [:input_image]
      )[:request]
    @request = Request.new(new_request_params)

    if @request.save
      PbnConverter.update(@request)
      #request_url goes to show page
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
    id = params.fetch('id')
    @request = Request.find(id)
    output =
      ActiveStorage::Blob.service.send(:path_for, @request.output_image.key)

    send_file(output, filename: 'output.png')
  end
end
