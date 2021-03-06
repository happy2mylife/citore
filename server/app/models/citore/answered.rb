# == Schema Information
#
# Table name: citore_answereds
#
#  id               :integer          not null, primary key
#  answer_user_type :string(255)      not null
#  answer_user_id   :integer          not null
#  input_word       :text(65535)      not null
#  output_word      :string(255)      not null
#  voice_id         :integer
#  image_id         :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  citore_answered_user_index  (answer_user_type,answer_user_id)
#

class Citore::Answered < ApplicationRecord
  belongs_to :answer_user, polymorphic: true
  has_one :voice, class_name: 'VoiceWord', foreign_key: :id
  has_one :image, class_name: 'Citore::EroticImage', foreign_key: :id
end
