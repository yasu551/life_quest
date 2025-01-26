class ApplicationForm
  include ActiveModel::API
  include ActiveModel::Attributes

  def model_name
    ActiveModel::Name.new(nil, nil, self.class.name.sub(/Form$/, ""))
  end

  def save
    return false if invalid?

    with_transaction { submit! }
  end

  private

  def with_transaction(&)
    ApplicationRecord.transaction(&)
  end

  def submit!
    raise NotImplementedError
  end
end
