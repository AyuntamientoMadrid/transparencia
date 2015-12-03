# Default admin user (change password after first deploy to a server!)
if Administrator.count == 0 && !Rails.env.test?
  Administrator.create!(email: 'admin@madrid.es', password: '12345678')
end
