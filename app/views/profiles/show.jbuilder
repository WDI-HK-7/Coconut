json.user_id @profile.user_id
json.content @profile.content
json.first_name @profile.first_name
json.last_name @profile.last_name
json.username @profile.username
json.avatar @profile.avatar.url(:medium)