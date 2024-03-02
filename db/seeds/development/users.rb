10.times do |n|
  name = "user#{n}"
  email = "#{name}@example.com"
  # fine_by(email: email, activated: true)がnilの場合に新規作成(User.new)、それ以外は取得(User.find_by)する
  user = User.find_or_initialize_by(email: email, activated: true)

  if user.new_record?
    user.name = name
    user.password = "password"
    user.save!
  end
end

puts "users = #{User.count}"
