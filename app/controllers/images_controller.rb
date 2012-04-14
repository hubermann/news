class ImagesController < ApplicationController
  # GET /images
  # GET /images.json
  def index
    @images = Image.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @images }
    end
  end

  # GET /images/1
  # GET /images/1.json
  def show
    @image = Image.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @image }
    end
  end

  # GET /images/new
  # GET /images/new.json
  def new
    @image = Image.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @image }
    end
  end

  # GET /images/1/edit
  def edit
    @image = Image.find(params[:id])
  end

  # POST /images
  # POST /images.json
  def create
    @image = Image.new(params[:image])

    if (params[:image][:filename])
    #function in manage_images.rb
    process_image(tmp = params[:image][:filename].tempfile)
    end
    identrie = params[:image][:entrie_id]
    respond_to do |format|
      if @image.save
        format.html { redirect_to entries_path, notice: 'Image was successfully created.' }
        format.json { render json: @image, status: :created, location: @image }
      else
     
        format.html { redirect_to image_new_path(identrie),  notice: ':('  }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /images/1
  # PUT /images/1.json
  def update
    @image = Image.find(params[:id])

    #si viene imagen en los parametros la subo
    if (params[:image][:filename])
    #traigo el nombre de la iamgen anterior al cambio
    imageold = @image.filename
    process_image(tmp = params[:image][:filename].tempfile)

    #remuevo la anterior
    remove_image_file(imageold)
    end

    #si viene titulo nuevo lo actualizo
    if(params[:image][:title])
    @image.title = params[:image][:title]
    end


    respond_to do |format|
      if @image.save #update_attributes(params[:image])
        format.html { redirect_to @image, notice: 'Image was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /images/1
  # DELETE /images/1.json
  def destroy
    @image = Image.find(params[:id])
    
    imagen = @image.filename
    
    #function in manage_images.rb
    remove_image_file(imagen)

    @image.destroy

    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :ok }
    end
  end

########### IMAGES FUNCTIONS ###########

############ BASIC PROCESS OF IMAGE ############
###### check if is valid image extencion #######
###### upload temporal file to server    #######
###### create thumbnails from original image ###

def process_image(tmp)
  random  = 2 + rand(10**24-10)+10
  path ="public/images/"
  file = File.join(path, random.to_s + "-" + params[:image][:filename].original_filename)

  #check extencion
    ext = File.extname(file)
    if ext.upcase == ".JPG"
      extfinal = ".jpg"
      imagevalid = true
    elsif ext.upcase == ".JPEG"
      extfinal = ".jpg"
      imagevalid = true
    elsif ext.upcase == ".GIF"
      extfinal = ".gif"
      imagevalid = true
    elsif ext.upcase == ".PNG"
      extfinal = ".png"
      imagevalid = true
    end 
    
  if imagevalid == true 

  #Subo la imagen original recibida
  FileUtils.cp tmp.path, file

  archivo_final = uploadoriginal(file,path)

  #utilizo su nombre
  filenamethumb = random.to_s + "-" + params[:image][:filename].original_filename
  #width desired / ancho deseado
  w = 150
  #function call / llamada a la funcion
  hubermann_thumbnail(path, filenamethumb,w,square=true, bw=true, q=99)
  hubermann_thumbnail(path, filenamethumb,w,square=true, bw=false, q=99)


  FileUtils.rm file


  @image.filename = archivo_final
  #end unless valid image
  else
  @image.filename = nil

  end
end  

###### UPLOAD BIGGER IMAGE (800px) ######
def uploadoriginal(file,path)
  ext = File.extname(file)
    if ext.upcase == ".JPG"
      extfinal = ".jpg"
    elsif ext.upcase == ".JPEG"
      extfinal = ".jpg"
    elsif ext.upcase == ".GIF"
      extfinal = ".gif"
    elsif ext.upcase == ".PNG"
      extfinal = ".png"
    end 


    #nombre original de la imagen
    filename_orig = File.basename(file, '.*')

    #remove white space in image name
    filename_orig = filename_orig.gsub(" ","-")

    width = 800

    image = Magick::Image.read(file).first

    widthimage = image.columns
    heightimage = image.rows
    height = (width * heightimage) / widthimage
    thumbnail = image.thumbnail(width, height)


    finalname = path + "800-" + filename_orig + extfinal
    q=99
    thumbnail.write(finalname){ self.quality = q }
    return filename_orig + extfinal
    
end

###### HUBERMANN THUMBNAILS ######
def hubermann_thumbnail(path,filename, w, square, bw,q)
  width = w

  image = Magick::Image.read(path+"/"+filename).first

  ext = File.extname(filename)
  if ext.upcase == ".JPG"
    extfinal = ".jpg"
  elsif ext.upcase == ".JPEG"
    extfinal = ".jpg"
  elsif ext.upcase == ".GIF"
    extfinal = ".gif"
  elsif ext.upcase == ".PNG"
    extfinal = ".png"
  end 

  #nombre original de la imagen
  filename_orig = File.basename(filename, '.*')

  #remove white space in image name
  filename_orig = filename_orig.gsub(" ","-")


  unless square 
    #proportional
    widthimage = image.columns
    heightimage = image.rows
    height = (width * heightimage) / widthimage
    thumbnail = image.thumbnail(width, height)
    finalname = path +  "/tn-p-" 
  else
    #square
    thumbnail = image.resize_to_fill(width, width)
    finalname = path +  "/tn-s-"
  end
  #grayscale 
  if bw == true
    thumbnail = thumbnail.quantize(256, Magick::GRAYColorspace)
    finalname = finalname + "g-"
  else
    finalname = finalname + "c-"
  end
  finalname = finalname + w.to_s + "-" + filename_orig + extfinal

  thumbnail.write(finalname){ self.quality = q }

end
###### REMOVE IMAGE ######
def remove_image_file(imagefile)
if File.exists?('public/images/800-' + imagefile)
    path = 'public/images/'
    File.delete('public/images/800-' + imagefile)
    File.delete('public/images/tn-s-c-150-' + imagefile)
    File.delete('public/images/tn-s-g-150-' + imagefile) 
    end
end

########### END IMAGES FUNCTIONS ###########


end
