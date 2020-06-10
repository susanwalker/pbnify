class Request < ApplicationRecord
  has_one_attached :input_image
  has_one_attached :output_image

  # This validates that every new request has an input image
  validate :input_image, presence: true
end
