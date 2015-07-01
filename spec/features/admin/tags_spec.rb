require 'rails_helper'

feature '后台标签管理', js: true do

  background do
    admin_sign_in create(:admin)
  end

  context '增' do
    scenario '用正确的值添加新标签' do
      tags_attrs = attributes_for(:tag)
      expect { create_tag_action(tags_attrs) }.to change(Tag, :count).by(1)
      expect(current_path).to eq admin_tags_path
      within 'div.alert-success' do
        expect(page).to have_content '标签创建成功'
      end
      expect(page).to have_content tags_attrs[:value]
    end

    scenario '用不正确的值添加新标签' do
      tags_attrs = attributes_for(:tag, value: nil)
      expect { create_tag_action(tags_attrs) }.to_not change(Tag, :count)
      within 'div.alert-danger' do
        expect(page).to have_content '标签创建失败'
      end
    end
  end

  context '查' do
    scenario '列表页有指定标签' do
      tag = create(:tag)
      visit admin_root_path
      click_link '标签'
      click_link '所有标签'
      expect(page).to have_content tag[:value]
    end
  end

  context '改' do
    given!(:tag) { create(:tag) }

    scenario '用正确的值修改标签' do
      update_tag_action('tag')
      tag.reload
      expect(tag.value).to eq 'tag'
      expect(current_path).to eq admin_tags_path
      within 'div.alert-success' do
        expect(page).to have_content '标签修改成功'
      end
    end

    scenario '用不正确的值修改标签' do
      update_tag_action(nil)
      tag.reload
      expect(tag.value).to_not be_nil
      expect(tag.value).to eq tag[:value]
      within 'div.alert-danger' do
        expect(page).to have_content '标签修改失败'
      end
    end
  end

  context '删' do
    scenario '删除标签', driver: :selenium do
      tag = create(:tag)
      visit admin_root_path
      click_link '标签'
      click_link '所有标签'
      expect(page).to have_content tag[:value]
      expect {
        click_link '删除'
        accept_alert('确定要删除吗？')
        sleep 1
      }.to change(Tag, :count).by(-1)
      expect(current_path).to eq admin_tags_path
      within 'div.alert-success' do
        expect(page).to have_content '标签删除成功'
      end
      expect(page).to_not have_content tag[:value]
    end
  end

  def create_tag_action(attrs)
    visit admin_root_path
    click_link '标签'
    click_link '新建标签'
    fill_in '内容', with: attrs[:value]
    click_button '提交'
  end

  def update_tag_action(value)
    visit admin_root_path
    click_link '标签'
    click_link '所有标签'
    click_link '编辑'
    fill_in '内容', with: value
    click_button '提交'
  end

end