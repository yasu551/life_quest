class AppliedScopesQuery < ApplicationQuery
  private attr_reader :applicable_scope_names

  def initialize(relation = self.class.query_model.all, applicable_scope_names = [].freeze)
    super(relation)
    @applicable_scope_names = applicable_scope_names
  end

  def resolve(scope_chains)
    scope_names = scope_chains.split(".")
    invalid_scope_names = scope_names - applicable_scope_names
    if invalid_scope_names.present?
      raise ArgumentError, "#{invalid_scope_names.join(", ")} is invalid"
    end

    scope_names.inject(relation) do |rel, scope_name|
      rel.public_send(scope_name)
    end
  end
end
