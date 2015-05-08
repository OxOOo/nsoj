class Access < ActiveRecord::Base
  belongs_to :user
  
  def has_access
    return self.is_root || self.is_admin || self.can_add_problem ||
      self.can_modify_problem || self.can_add_contest || self.can_modify_contest
  end
end
