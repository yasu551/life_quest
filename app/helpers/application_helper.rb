module ApplicationHelper
  def nl(object, **options)
    unless object.nil?
      l(object, **options)
    end
  end

  def submit_button_label(record)
    record.new_record? ? "作成" : "更新"
  end
end
