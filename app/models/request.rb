class Request < ApplicationRecord
  # TODO: enforce attachment type to be image
  has_one_attached :input_image
  has_one_attached :output_image

  # This validates that every new request has an input image
  validates :input_image, presence: true
end
