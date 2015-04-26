module Ep
  class Lib
    def self.bucket_path(bucket_suffix)
      "ep-#{ENV['EP_AWS_S3BUCKET']}-#{bucket_suffix}"
    end

    def self.get_suggestions(user)
      if user.has_colleges?
        college_user_ids = []
        user.colleges.each do |college|
          college_user_ids << college.user_ids
        end
        college_user_ids.flatten!
        college_user_suggestions = User.in(id: college_user_ids).ne(id: user.id, as_org: true)
      else
        college_user_suggestions = []
      end

      if user.has_subjects?
        subject_user_ids = []
        user.subjects.each do |subject|
          subject_user_ids << subject.user_ids
        end
        subject_user_ids.flatten!
        subject_user_suggestions = User.in(id: subject_user_ids).ne(id: user.id, as_org: true)
      else
        subject_user_suggestions = []
      end

      if user.is_admin?
        admin_role = Role.where(name: 'Administrator').first
        role_user_suggestions = admin_role.users.ne(id: user.id, as_org: true)
        role_user_suggestions = [] if role_user_suggestions.blank?
      else
        role_user_suggestions = []
      end

      suggestions = (college_user_suggestions + subject_user_suggestions + role_user_suggestions)
      if suggestions.blank?
        @suggestions = User.all.ne(id: user.id, as_org: true).shuffle.first(3)
      else
        @suggestions = suggestions.shuffle.first(3)
      end
    end

  end
end