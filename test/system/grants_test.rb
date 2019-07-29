require "application_system_test_case"

class GrantsTest < ApplicationSystemTestCase
  setup do
    @grant = grants(:one)
  end

  test "visiting the index" do
    visit grants_url
    assert_selector "h1", text: "Grants"
  end

  test "creating a Grant" do
    visit grants_url
    click_on "New Grant"

    fill_in "Project", with: @grant.project
    fill_in "Resource", with: @grant.resource
    click_on "Create Grant"

    assert_text "Grant was successfully created"
    click_on "Back"
  end

  test "updating a Grant" do
    visit grants_url
    click_on "Edit", match: :first

    fill_in "Project", with: @grant.project
    fill_in "Resource", with: @grant.resource
    click_on "Update Grant"

    assert_text "Grant was successfully updated"
    click_on "Back"
  end

  test "destroying a Grant" do
    visit grants_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Grant was successfully destroyed"
  end
end
