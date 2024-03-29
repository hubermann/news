class EntriesController < ApplicationController

  before_filter :authorize, :except => [:show, :index]
  # GET /entries
  # GET /entries.json
  def index
    if params[:id]
      @entries = Entry.where(:cat_id => params[:id])
    else
      @entries = Entry.all
    end
    
      
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @entries }
    end
  end

def news
    if params[:id]
      @entries = Entry.where(:cat_id => params[:id])
    else
      @entries = Entry.all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @entries }
    end
  end


  def update_main
    @entry = Entry.find(params[:entrie_id])
    
    @entry.mainimg = params[:setmain]
    respond_to do |format|
      if @entry.save
        format.html { redirect_to @entry, notice: 'Entry was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "show" }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end
  # GET /entries/1
  # GET /entries/1.json
  def show
    @entry = Entry.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @entry }
    end
  end

  # GET /entries/new
  # GET /entries/new.json
  def new
    @entry = Entry.new
    @cats = Cat.all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @entry }
    end
  end

  # GET /entries/1/edit
  def edit
    @entry = Entry.find(params[:id])
  end

  # POST /entries
  # POST /entries.json
  def create
    @entry = Entry.new(params[:entry])

    respond_to do |format|
      if @entry.save
        format.html { redirect_to @entry, notice: 'Entry was successfully created.' }
        format.json { render json: @entry, status: :created, location: @entry }
      else
        format.html { render action: "new" }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /entries/1
  # PUT /entries/1.json
  def update
    @entry = Entry.find(params[:id])

    respond_to do |format|
      if @entry.update_attributes(params[:entry])
        format.html { redirect_to @entry, notice: 'Entry was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /entries/1
  # DELETE /entries/1.json
  def destroy
    @entry = Entry.find(params[:id])
    @entry.destroy

    respond_to do |format|
      format.html { redirect_to entries_url }
      format.json { head :ok }
    end
  end
end
