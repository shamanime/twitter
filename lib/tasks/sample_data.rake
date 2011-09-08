namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Mongoid.master.collections.reject { |c| c.name =~ /^system/}.each(&:drop)
    
    User.create!(:name => "Jefferson Queiroz",
                 :email => "jefferson@shamanime.com",
                 :password => "123456",
                 :password_confirmation => "123456")
    
    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      User.create!(:name => name,
                   :email => email,
                   :password => password,
                   :password_confirmation => password)
    end
    
    User.all(:limit => 6).each do |user|
      50.times do
        user.microposts.create!(:content => Faker::Lorem.sentence(5))
      end
    end
    
  end
end