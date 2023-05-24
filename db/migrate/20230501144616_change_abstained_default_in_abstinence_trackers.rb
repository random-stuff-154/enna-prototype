class ChangeAbstainedDefaultInAbstinenceTrackers < ActiveRecord::Migration[6.1]
  def change
    change_column_default :abstinence_trackers, :abstained, nil
  end
end
