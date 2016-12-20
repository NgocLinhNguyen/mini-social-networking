json.comments @comments.each do |comment|
  json.comment @comment
  json.user @comment.user
  json.avatar @comment.user.try(:avatar).try(:picture).try(:thumb).try(:url)
end
