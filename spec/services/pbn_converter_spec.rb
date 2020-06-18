require 'rails_helper'

RSpec.describe PbnConverter do
  describe 'update' do
    # let!(:x) { 2 } in rspec is eqivalent to x = 2
    let!(:input_image) do
      path = Rails.root.join('spec', 'support', 'test_image.png')
      fixture_file_upload(path, 'image/png')
    end

    let!(:request) do
      Request.new(input_image: input_image)
    end

    before do
      allow(PbnConverter).to receive(:remove_insignificant_colors) { |m| m }
    end

    it 'adds an output_image to the request' do
      expect(request.output_image.present?).to eq(false)
      PbnConverter.update(request)
      expect(request.output_image.present?).to eq(true)
    end
  end
end
