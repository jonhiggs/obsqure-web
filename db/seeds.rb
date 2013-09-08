u = User.new(
  :email => "admin@obsqure.me",
  :password => 'adminadmin'
)
u.save!(:validate => false)
