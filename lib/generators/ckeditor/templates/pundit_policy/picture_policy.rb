class Ckeditor::PicturePolicy
  attr_reader :user, :picture

  def initialize(user, picture)
    @user = user
    @picture = picture
  end

  def index?
    true and ! @user.nil?
  end

  def create?
    true and ! @user.nil?
  end

  def destroy?
    @picture.assetable_id == @user.id
  end
end