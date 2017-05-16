module EmailsHelper
  def emailable_performance_sets
    if current_user.global_admin?
      return PerformanceSet.all.emailable
    else
      return PerformanceSet.where(ensemble_id: UserEnsemble.where(user_id: current_user.id).map(&:ensemble_id)).emailable
    end
  end
end
