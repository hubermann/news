module ImagesHelper

	def bringmainimg(identry)
		entry = Entry.find(identry)

		image = Image.find(entry.mainimg)

		@image_file =  image.filename 
		@image_title = image.title 
	end

end
