class PostsController < ApplicationController
	
#	before_action :authenticate_user!
	
	def index
		
		@posts = Post.all
		#.includes(:comments)
		
	end
	
	def create
		
		@post = current_user.posts.new(post_params)
		
		if @post.save
			render :json => { message: "saved" }
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
				message: "You are not signed in!"
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
		params.require(:post).permit(:title, :content, :category, :picture)
	end

end
