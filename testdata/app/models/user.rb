# @see https://github.com/flyerhzm/rails_best_practices/blob/HEAD/spec/rails_best_practices/reviews/default_scope_is_evil_review_spec.rb#L12-L14
# @see https://github.com/flyerhzm/rails_best_practices/blob/HEAD/spec/rails_best_practices/reviews/protect_mass_assignment_review_spec.rb#L17-L18
class User < ActiveRecord::Base
  default_scope -> { order('created_at desc') }
end
