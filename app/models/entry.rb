class Entry < ActiveRecord::Base
	belongs_to :cat
	validates_presence_of :title, :description
end
