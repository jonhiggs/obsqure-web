u = User.new(
  :email => "admin@obsqure.net",
  :password => 'adminadmin'
)
u.save!(:validate => false)
