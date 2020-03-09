module UserHelper
  def gender_user user
    if user.gender == "female"
      Settings.user.gender_female
    elsif user.gender == "male"
      Settings.user.gender_male
    elsif user.gender == "other"
      Settings.user.gender_other
    end
  end

  def arr_gender
    User.genders.map do |key, value|
      [key, value]
    end
  end

  def display_avatar_image user
    user.avatar_image.attached? ? user.avatar_image : Settings.user.default_avt
  end
end
