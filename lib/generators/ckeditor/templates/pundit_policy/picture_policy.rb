class Ckeditor::PicturePolicy
  attr_reader :user, :picture

  def initialize(user, picture)
    @user = user
    @picture = picture
  end

  def index?
    user.present?
  end

  def create?
    user.present?
  end

  def destroy?
    picture.assetable_id == user.id
  end
end