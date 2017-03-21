class Deck < ActiveRecord::Base
  has_many :deck_cards
  has_many :deck_gems
end
