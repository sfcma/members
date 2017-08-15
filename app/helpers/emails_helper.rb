module EmailsHelper
  def emailable_performance_sets
    if current_user.global_admin?
      PerformanceSet.all.emailable
    else
      PerformanceSet.where(ensemble_id: UserEnsemble.where(user_id: current_user.id).map(&:ensemble_id)).emailable
    end
  end

  def emailable_ensembles
    if current_user.global_admin?
      Ensemble.all
    else
      Ensemble.find_by(id: UserEnsemble.where(user_id: current_user.id).map(&:ensemble_id))
    end
  end
end
