namespace :db do
  desc "Updates subjects"
  task :update_subjects => :environment do

    new_subject_names = [
      'Art',
      'Bilingual Education',
      'Dual Language Education',
      'Early Childhood',
      'English Language Arts',
      'ESL',
      'Foreign Languages',
      'History/Social Studies',
      'Library',
      'Literacy',
      'Math',
      'Physical Education',
      'Science',
      'Special Education',
      'Speech',
      'Technology'
    ]

    old_subjects = Subject.all
    old_subject_names = old_subjects.pluck(:name)

    for name in new_subject_names
      next if old_subject_names.include? name
      new_subject = Subject.create(name: name)
    end

    old_subjects.each do |old_subject|
      old_subject.delete if !new_subject_names.include? old_subject.name
    end

  end
end