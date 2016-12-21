arr_name = ["Linh", "Long", "Ngan", "Hoa", "Loan", "Nguyen", "Tuan", "Viet"]

arr_name.each do |name|
  User.create(
    name: name,
    email: name + "@test.com",
    password: "member123",
    password_confirmation: "member123",
    status: "active"
  )
end
