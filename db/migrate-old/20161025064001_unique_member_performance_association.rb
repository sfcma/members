class UniqueMemberPerformanceAssociation < ActiveRecord::Migration[5.0]
  def change
    # Remove duplicates first
    MemberSet.all.group_by(&:member_id).map do |_, member_sets|
      member_sets.group_by(&:performance_set_id).each do |_, member_sets|
        member_sets[1..-1].each(&:destroy)
      end
    end

    add_index :member_sets, [:member_id, :performance_set_id], unique: true
  end
end
