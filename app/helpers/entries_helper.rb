module EntriesHelper

	def bringimages(entrie)
		@images = Image.where(:entrie_id => entrie)
	end

end
