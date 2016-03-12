# We need to make sure campus data matches TIYO, but
#   1) don't want to manually unify names and
#   2) don't much care about existing campus data
class ClearCampuses < ActiveRecord::Migration
  class Campus < ActiveRecord::Base; end
  class Yardigan < ActiveRecord::Base; end

  def change
    cs = Campus.where(tiyo_id: nil)
    Yardigan.where(campus_id: cs.pluck(:id)).update_all(campus_id: nil)
    cs.delete_all
  end
end
