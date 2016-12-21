if @users
  json.users (@users) do |user|
    json.user user
    if user.avatar
      json.avatar user.avatar.picture.profile_small.url
    end
  end
end

if @groups
  json.groups (@groups) do |group|
    json.group group
    if group.cover
      json.cover group.cover.picture.profile_small.url
    end
  end
end

json.message @message
