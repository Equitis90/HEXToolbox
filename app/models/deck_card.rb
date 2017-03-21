class DeckCard < ActiveRecord::Base
  belongs_to :deck, :dependent => :destroy
end
