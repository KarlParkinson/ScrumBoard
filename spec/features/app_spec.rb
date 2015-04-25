require 'rails_helper'

feature "creating new board", :js => true do
  scenario "creating a new board" do
    visit '/auth/google_oauth2/callback'
    visit '/boards'
    click_link 'new-board-link'
    fill_in 'board-name', :with => 'testing'
    click_button 'Create'
    visit '/boards'
    within 'div#boards_region' do
      expect(page).to have_content 'testing'
    end
  end
end

feature "renaming a board", :js => true do
  scenario "clicking 'Rename' link" do
    visit '/auth/google_oauth2/callback'
    visit '/boards'
    click_link 'new-board-link'
    fill_in 'board-name', :with => 'testing'
    click_button 'Create'
    click_link "Rename"
    fill_in  'board-name', :with => 'testing edited name'
    click_button 'Rename'
    within 'h4#board-name' do
      expect(page).to have_content 'testing edited name'
    end
    visit '/boards'
    within 'div#boards_region' do
      expect(page).to have_content 'testing'
    end
  end
end

feature "using a board", :js => true do
  scenario "creating, editing, and deleting tasks" do
    visit '/auth/google_oauth2/callback'
    visit '/boards'
    click_link 'new-board-link'
    fill_in 'board-name', :with => 'testing'
    click_button 'Create'

    within 'div#todo' do
      fill_in 'task-body-todo', :with => 'test task'
      click_button 'Create'
      within 'ul#todo-tasks-container' do
        expect(page).to have_content 'test task'
      end
    end

    find('.task-list-entry').hover
    click_link "Edit"
    fill_in 'task-description', :with => 'test task edited'
    click_button 'Save'
    within 'ul#todo-tasks-container' do
      expect(page).to have_content 'test task edited'
    end

    find('.task-list-entry').hover
    accept_confirm do
      click_link "Delete"
    end
    within 'ul#todo-tasks-container' do
      expect(page).to have_no_content 'test task edited'
    end
  end
end
