require 'rails_helper'

RSpec.describe Request, type: :model do
  describe 'input_image' do
    let!(:request) do
      Request.new(input_image: input_image)
    end

    context 'when input image is nil' do
      let!(:input_image) { nil }

      it 'says the request is not valid' do
        expect(request.valid?).to eq(false)
      end
    end

    context 'when input image is not nil' do
      # let! is the way to assign a variable instead of "="
      let!(:input_image) do
        # This is the path to the test image we use for testing (penguin image)
        path = Rails.root.join('spec', 'support', 'test_image.png')
        fixture_file_upload(path, 'image/png')
      end

      it 'says the request is valid' do
        expect(request.valid?).to eq(true)
      end
    end
  end

  describe 'output_image (given there is an input image)' do
    let!(:input_image) do
      path = Rails.root.join('spec', 'support', 'test_image.png')
      fixture_file_upload(path, 'image/png')
    end

    let!(:request) do
      Request.new(input_image: input_image, output_image: output_image)
    end

    context 'when output image is nil' do
      let!(:output_image) { nil }

      it 'says the request is valid' do
        expect(request.valid?).to eq(true)
      end
    end

    context 'when output image is not nil' do
      let!(:output_image) { input_image }

      it 'says the request is valid' do
        expect(request.valid?).to eq(true)
      end
    end
  end
end
