class Ckeditor::AttachmentFilePolicy
  attr_reader :user, :attachment

  def initialize(user, attachment)
    @user = user
    @attachment = attachment
  end

  def index?
    true and ! @user.nil?
  end

  def create?
    true and ! @user.nil?
  end

  def destroy?
    @attachment.assetable_id == @user.id
  end
end