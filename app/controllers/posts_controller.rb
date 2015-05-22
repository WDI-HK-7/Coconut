class PostsController < ApplicationController
  before_action :authenticate_user!
  
  def around
    post = Post.find_by_id(params[:id])
    @posts = Post.where("latitude > ?" , post.latitude - 0.001).where("latitude < ?" , post.latitude + 0.001).where("longitude > ?" , post.longitude - 0.001).where("longitude < ?" , post.longitude + 0.001)
  end

  def live_feed(postId, searchRadius)
    post = Post.find_by_id(postId)
    return Post.order(taken_at: :desc).where("latitude > ?" , post.latitude - searchRadius).where("latitude < ?" , post.latitude + searchRadius).where("longitude > ?" , post.longitude - searchRadius).where("longitude < ?" , post.longitude + searchRadius).where("taken_at > ?", post.taken_at - 1.hour).includes(:comments)
  end

  def userPosts
    @posts = User.find_by_id(params[:user_id]).posts.all.includes(:comments)
  end

  def index

    search_radius = 0.001
    post = current_user.posts.order(taken_at: :desc).first
    # return render :json => { post: timezone.time(Time.now) }
    if post.nil?
      return @posts = Post.all.includes(:comments)
    end
    
    timezone = Timezone::Zone.new :zone => post.timezone
    if post.taken_at > (timezone.time(Time.now) - 1.hour)
      @posts = live_feed(post.id, search_radius)
    else
      @posts = Post.all.includes(:comments)
    end
    
  end
  
  def create

    file = params[:post][:picture].tempfile
    exifr = EXIFR::JPEG.new(file)
    if exifr.gps_longitude.nil?
      puts "------------- exifr is empty"
    else
      puts "------------- exifr is not empty"
    end
    puts "exifr -------------------- datetime: #{exifr.date_time} lon: #{exifr.gps_longitude} lat: #{exifr.gps_latitude}"
    
    converted = convert_coordinates_to_float(exifr)

    @post = current_user.posts.new(post_params)

    timezone = Timezone::Zone.new :latlon => [converted[:latitude], converted[:longitude]]
    @post.timezone = timezone.zone
    @post.longitude = converted[:longitude]
    @post.latitude = converted[:latitude]
    @post.taken_at = exifr.date_time
    puts "post file ----------------- #{@post.inspect}"
    
    if @post.save!
      puts "-------------------------------------saved----------------------------"
      render :json => { message: "saved", post: @post, photo: exifr }
    else
      puts "---------------------------------not saved----------------------------"
      puts @post.errors.full_messages
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
    params.require(:post).permit(:description, :picture, :lon, :lat)
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
