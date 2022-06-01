class Book < ApplicationRecord
  validates :author, :title, presence: true, length: { minimum: 3 }
end
