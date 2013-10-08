default_users = [
  { :username => "admin", :password => "xi5xe6uj" },
  { :username => "administrator", :password => "or1poh9o" },
  { :username => "ftp", :password => "vootaht6" },
  { :username => "guest", :password => "dai2dahd" },
  { :username => "jon", :password => "po5ay1ve", :account_type => 99 },
  { :username => "postmaster", :password => "moba0ahw" },
  { :username => "root", :password => "taethoo6" },
  { :username => "support", :password => "ien2iph2" }
]

default_users.each do |user|
  u = User.new(user)
  u.save!(:validate => false)
end
