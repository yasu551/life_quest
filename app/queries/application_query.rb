class ApplicationQuery
  private attr_reader :relation

  class << self
    def query_model
      name.sub(/::[^:]+$/, "").safe_constantize
    end

    def resolve(...)
      new.resolve(...)
    end

    alias_method :call, :resolve
  end

  def initialize(relation = self.class.query_model.all)
    @relation = relation
  end

  def resolve(...)
    relation
  end
end
