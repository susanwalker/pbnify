require 'rails_helper'

RSpec.describe 'require#show', type: :system do

  let!(:input_image) do
    path = Rails.root.join('spec', 'support', 'test_image.png')
    fixture_file_upload(path, 'image/png')
  end

  let!(:request) do
    Request.create(input_image: input_image, output_image: output_image)
  end

  context 'when output image is present' do
    let!(:output_image) { input_image }

    it 'renders the page with output_image' do
      visit "/requests/#{request.id}"
      expect(page).to have_text("Final PBNified Image")
      expect(page).to have_css("img[class='img-responsive']")
    end
  end

  context 'when output image is not present' do
    let!(:output_image) { nil }

    it 'renders the page without output_image' do
      visit "/requests/#{request.id}"
      expect(page).to have_text("Final PBNified Image")
      expect(page).to have_text("No output available")
    end
  end
end
