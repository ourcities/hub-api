class WidgetSerializer < ActiveModel::Serializer
  attributes :id, :block_id, :kind, :settings, :sm_size, :md_size, :lg_size,
    :form_entries_count, :donations_count, :created_at, :updated_at,
    :action_community, :action_opportunity, :exported_at, :match_list, :count,
    :goal

  def match_list
    object.matches
  end

  #
  # Find a way to remove the attributes match_list, form_entries_count and donations_count
  # depending by the widget kind e.g. Is not necessary to have `form_entries_count` if widget
  # kind is pressure.
  #
  def count
    object.activist_pressures.count
  end

  def settings
    return unless object.settings
    v = object.settings.to_s.gsub! '=>', ':'
    if v.nil?
      return JSON.parse(object.settings.to_s)
    else
      return JSON.parse(v)
    end
  end

  def form_entries_count
    object.form_entries.count
  end

  def donations_count
    object.donations.count
  end

  def action_opportunity
    object.form?
  end
end
