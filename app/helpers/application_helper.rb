module ApplicationHelper
  def submit_button_label(record)
    record.new_record? ? "作成" : "更新"
  end
end
