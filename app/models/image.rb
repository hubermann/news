class Image < ActiveRecord::Base
	belongs_to :entry
	validates_presence_of :title, :filename
	validates_presence_of :entrie_id
end
