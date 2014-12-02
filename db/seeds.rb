# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

users = User.all
for user in users
	if user.demo == true
		user.destroy
	end
end

skills = ["Backward Design", "Common Core State Standards", "Microsoft Office", "School Programming", "Differentiated Instruction", "SMARTboard", "Graphing Calculator", "Data Analysis", "Unit Mapping","Danielson Framework", "Secondary Education"]
roles = %w(teacher administrator counselor)
subjects =  %w(math english history science sped art physed)

30.times do
	user = User.create(demo: true,
                     first_name: Faker::Name.first_name,
                     last_name: Faker::Name.last_name,
                     email: Faker::Internet.email,
                     password: "asdfasdf",
                     password_confirmation: "asdfasdf",
                     pro_summary: Faker::Lorem.paragraph(sentence_count = 3, supplemental = false, random_sentences_to_add = 3),
                     skill: "Bowling",
                     headline: Faker::Lorem.sentence(word_count = 5, supplemental = false, random_words_to_add = 6),
                     image_url: Faker::Avatar.image,
                     role: roles.sample,
                     subject_area: subjects.sample)

	4.times do
		user.skills.create(:name => skills.sample)
	end
end
