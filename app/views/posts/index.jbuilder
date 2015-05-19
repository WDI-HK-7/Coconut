json.array! @posts do |post|

	json.id post.id
	json.description post.description
	json.picture post.picture
	json.taken_at post.taken_at
	json.latitude post.latitude
	json.longitude post.longitude
	
#	json.comments post.comments do |comment|
#	
#		json.content comment.content
#		json.created_at comment.created_at
#		json.user_id comment.user_id
#	
#	end
	

end