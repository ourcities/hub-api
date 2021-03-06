class NotificationTemplate < ActiveRecord::Base
  belongs_to :community
  validates :subject_template, :body_template, :label, presence: true
  validates :label, format: { with: /\A[\0-9a-zA-Z\_]+\z/ }
  validates :label, uniqueness: { scope: :community_id }
  before_save :down_label

  def generate_subject vars
    template_parser(subject_template).render(vars.deep_stringify_keys)
  end

  def generate_body vars
    template_parser(body_template).render(vars.deep_stringify_keys)
  end

  protected

  def template_parser content
    @template = Liquid::Template.parse(content)
  end

  def down_label
    self.label.downcase!
  end
end
