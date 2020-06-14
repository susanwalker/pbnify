require 'rails_helper'

RSpec.describe 'request#new', type: :system do
  describe 'form' do
    it 'renders a request form with input image field' do
      visit '/requests/new'
      expect(page).to have_text('Welcome to PBNify!')
      expect(page).to have_text('Upload an image for PBNification')
    end
  end

  describe 'submit' do
    before do
      visit '/requests/new'
    end

    context 'when not input image is attached' do
      it 'renders the new form with errors' do
        click_button 'Create Request'
        expect(current_path).to eq('/requests')
        expect(page).to have_text("Input image can't be blank")
      end
    end

    context 'when an input image is attached' do
      let!(:filepath) { Rails.root.join('spec', 'support', 'test_image.png') }

      it 'renders the show page of the request with an output image' do
        attach_file 'request_input_image', filepath
        click_button 'Create Request'
        expect(current_path).not_to eq('/requests')
        expect(page).to have_text('Final PBNified Image')
      end
    end
  end
end
