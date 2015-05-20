class PostsController < ApplicationController
  
# before_action :authenticate_user!
  
  def index
    
    @posts = Post.all
    #.includes(:comments)
    
  end
  
  def create

    file = params[:post][:picture].tempfile
    exifr = EXIFR::JPEG.new(file)
    
    converted = convert_coordinates_to_float(exifr)

    @post = Post.new(post_params)


    @post.longitude = converted[:longitude]
    @post.latitude = converted[:latitude]
    @post.taken_at = exifr.date_time
    
    if @post.save
      render :json => { message: "saved", post: @post}
    else
      render :json => { message: "not saved" }
    end
    
  end
  
  def show
    
    @post = Post.find_by_id(params[:id])
    
    if @post.nil?
      render :json => {
        message: "Can't find post with id #{params[:id]}"
      }
    end
  
  end

  def update
    
    @post = Post.find_by_id(params[:id])
    
    if @post.user == current_user
      if @post.nil?
        render :json => {
          message: "Can't find post with id #{params[:id]}"
        }
      else
        if @post.update(post_params)
          render :json => { message: "updated" }
        else
          render :json => { message: "not updated" }
        end
      end
    else
      render :json => {
        message: "You are not authorized!"
      }
    end
  
  end

  def destroy
    
    @post = Post.find_by_id(params[:id])
    
    if @post.nil?
      render :json => {
        message: "Can't find post with id #{params[:id]}"
      }
    else
      if @post.destroy
        render :json => {
          message: "message deleted"
        }
      else
        render :json => {
          message: "not deleted"
        }
      end
    end

  end
  
  private
  
  def post_params
    params.require(:post).permit(:description, :picture)
  end

  def convert_to_decimal(coordinates)
    (coordinates[0].to_r.to_f + ( coordinates[1].to_r.to_f / 60 ) + (coordinates[2].to_r.to_f / 3600 )).round(6)  
  end

  def convert_coordinates_to_float(metadata)

    longitude = convert_to_decimal(metadata.gps_longitude)
    latitude = convert_to_decimal(metadata.gps_latitude)

    if metadata.gps_longitude_ref == "W"
      longitude = longitude * -1
    end

    if metadata.gps_latitude_ref == "S"
      latitude = latitude * -1
    end

    convertedCoordinates = Hash.new

    convertedCoordinates[:longitude] = longitude
    convertedCoordinates[:latitude] = latitude
    return convertedCoordinates

  end

end
