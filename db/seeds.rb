u = User.new(
  :username => "admin",
  :password => "adminadmin"
)
u.save!(:validate => false)
