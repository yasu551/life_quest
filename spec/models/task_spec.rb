require 'rails_helper'

RSpec.describe Task, type: :model do
  describe ".tagged_with" do
    let_it_be(:user) { create(:user) }
    let_it_be(:tag1) { create(:tag, user:, name: "tag 1", color: "#ff0000") }
    let_it_be(:tag2) { create(:tag, user:, name: "tag 2", color: "#ff0000") }
    let_it_be(:task1) { create(:task, user:, name: "task 1", tag_ids: [ tag1.id ]) }
    let_it_be(:task2) { create(:task, user:, name: "task 2", tag_ids: [ tag2.id ]) }
    let_it_be(:task3) { create(:task, user:, name: "task 3", tag_ids: [ tag1.id, tag2.id ]) }
    let_it_be(:task4) { create(:task, user:, name: "task 4") }

    specify "指定したタグに関連するタスクを取得できること" do
      expect(Task.tagged_with(tag1).pluck(:id)).to contain_exactly(task1.id, task3.id)
      expect(Task.tagged_with(tag2).pluck(:id)).to contain_exactly(task2.id, task3.id)
      expect(user.tasks.tagged_with(tag1).pluck(:id)).to contain_exactly(task1.id, task3.id)
      expect(user.tasks.tagged_with(tag2).pluck(:id)).to contain_exactly(task2.id, task3.id)
    end
  end
end
