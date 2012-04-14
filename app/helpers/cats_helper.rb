module CatsHelper

	def nombrecat(idcat)
		cat = Cat.find(idcat)
		category_name = cat.name
		return category_name
	end


end



