User.create!(name: "Prashant Pandey",
             email: "prashantpandey@gmail.com",
             password: "Inferno2",
             password_confirmation: "Inferno2",
             admin: true)
99.times do |n|
    name = "#{n+1}Prashant"
    email = "examples-#{n+1}@gl.in"
    password = "password"
    User.create!(name: name,
                 email: email,
                 password: password,
                 password_confirmation: password)
end