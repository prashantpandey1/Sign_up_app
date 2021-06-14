# Users
User.create!(name: "Prashant Pandey",
             email: "prashantpandey@gmail.com",
             password: "Inferno2",
             password_confirmation: "Inferno2",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)
99.times do |n|
    name = "#{n+1}Prashant"
    email = "examples-#{n+1}@gl.in"
    password = "password"
    User.create!(name: name,
                 email: email,
                 password: password,
                 password_confirmation: password,
                 activated: true,
                 activated_at: Time.zone.now)
end

# Microposts
users = User.order(:created_at).take(6)
50.times do |n|
  content = "#{n+1} Prashant Microposts,similar for everyone it's hard coded"
  users.each { |user| user.microposts.create!(content: content)}
end

# following relationships
users = User.all
user = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user)}
