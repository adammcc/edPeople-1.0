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
College.delete_all
CollegeInfo.delete_all
Role.delete_all
Subject.delete_all
JobPost.delete_all
Location.delete_all

skills = ["Backward Design", "Common Core State Standards", "Microsoft Office", "School Programming", "Differentiated Instruction", "SMARTboard", "Graphing Calculator", "Data Analysis", "Unit Mapping","Danielson Framework", "Secondary Education"]
roles = %w(Teacher Administrator Counselor)
subjects =  %w(Math English History Science Sped Art Physed)
college_names = ['Williams College', 'Stanford University', 'Swarthmore College', 'Princeton University', 'Massachusetts Institute of Technology', 'Yale University', 'Harvard University']
locations = ['Bronx', 'Brooklyn', 'Queens', 'Manhattan', 'Staten Island', 'Long Island', 'Westchester County', 'Rockland County']
school_names = ['The edPeople School', 'Renaissance High School', 'Nyack High School', 'Bronx Science High School']

roles.each do |role_name|
  Role.create(name: role_name)
end

subjects.each do |subject_name|
  Subject.create(name: subject_name)
end

locations.each do |location|
  Location.create(name: location)
end

30.times do
	user = User.create(
    demo: true,
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
    password: "asdfasdf",
    password_confirmation: "asdfasdf",
    pro_summary: Faker::Lorem.paragraph(sentence_count = 3, supplemental = false, random_sentences_to_add = 3),
    skill: "Bowling",
    headline: Faker::Lorem.sentence(word_count = 5, supplemental = false, random_words_to_add = 6),
    image_url: Faker::Avatar.image,
    roles: [Role.all.sample],
    subjects: [Subject.all.sample]
  )

	4.times do
		user.skills.create(:name => skills.sample)
	end
end

college_names.each do |college_name|
  College.create(name: college_name)
end

10.times do
  job = JobPost.create(
    title: "#{subjects.sample} Teacher",
    location: locations.sample,
    neighborhood: locations.sample,
    organization: school_names.sample,
    contact_info: Faker::Internet.email,
    org_website: 'www.edpeople.com',
    description: Faker::Lorem.paragraph(sentence_count = 30, supplemental = false, random_sentences_to_add = 20)
  )
end

JobPost.all.each do |job|
  job.role = Role.all.sample
  job.subject = Subject.all.sample
  job.location = Location.all.sample
  job.save
end
