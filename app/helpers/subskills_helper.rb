module SubskillsHelper
  def subskills_fit_css(score)
    succ_thresh = Setting.plugin_redmine_subskills['fit_success_threshold'].to_i
    warn_thresh = Setting.plugin_redmine_subskills['fit_warning_threshold'].to_i
    if score >= succ_thresh
      'fit-high'
    elsif score >= warn_thresh
      'fit-mid'
    else
      'fit-low'
    end
  end

  def subskills_succ_thresh
    Setting.plugin_redmine_subskills['fit_success_threshold'].to_i
  end

  def subskills_warn_thresh
    Setting.plugin_redmine_subskills['fit_warning_threshold'].to_i
  end
end
