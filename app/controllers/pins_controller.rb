class PinsController < ApplicationController
  before_action :set_pin, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_filter :authenticate_user!, except: [:index]

  def index
    @pins = Pin.all.order("created_at DESC").paginate(:page => params[:page], :per_page => 8)
    @current_user = current_user
 end

  def show
  end

  def new
    @pin = current_user.pins.build
  end

  def edit
  end

  def create
    @pin = current_user.pins.build(pin_params)
   
    if @pin.save
     redirect_to @pin, notice: 'Pin was successfully created.' 

    else
     render :new 
      end
    end

  def update

    if @pin.update(pin_params)
      redirect_to @pin, notice: 'Pin was successfully updated.' 
    
    else
      render :edit 
    
      end
    end


  def destroy
    @pin.destroy
      redirect_to pins_url, notice: 'Pin was successfully destroyed.' 
    end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pin
      @pin = Pin.find(params[:id])
    end

    def correct_user
   Rails.logger.info "Parameter id is: #{params[:id]}"
   Rails.logger.info "Current user is: #{current_user}"
    person_pin = Pin.find_by_user_id_and_id(current_user, params[:id])
   Rails.logger.info "Is person_pin nil: #{person_pin.nil?}"
   Rails.logger.info person_pin
   redirect_to pins_path, notice: "Not authorized to edit this pin" if person_pin.nil? unless current_user.admin
  end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pin_params
      params.require(:pin).permit(:description, :image)
    end
end
