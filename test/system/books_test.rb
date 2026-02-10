require "application_system_test_case"

class BooksTest < ApplicationSystemTestCase
  include OmniAuthTestHelper

  setup do
    @book = books(:one)
    @admin = admins(:one)

    # Configure OmniAuth mock
    sign_in_admin(@admin)
  end

  # Helper to log in via OAuth callback in system tests
  def login_via_oauth
    visit "/admins/auth/google_oauth2/callback"
  end

  # Sunny day: authenticated user can visit index
  test "visiting the index after login" do
    login_via_oauth
    visit books_url
    assert_selector "h1", text: "Books"
    assert_selector "h1", text: "You're logged in! Welcome!"
  end

  # Sunny day: authenticated user can create a book
  test "should create book" do
    login_via_oauth
    visit books_url
    click_on "New book"

    fill_in "Title", with: "Test Book Title"
    click_on "Create Book"

    assert_text "Book was successfully created"
    click_on "Back"
  end

  # Sunny day: authenticated user can update a book
  test "should update Book" do
    login_via_oauth
    visit book_url(@book)
    click_on "Edit this book", match: :first

    fill_in "Title", with: @book.title
    click_on "Update Book"

    assert_text "Book was successfully updated"
    click_on "Back"
  end

  # Sunny day: authenticated user can destroy a book
  test "should destroy Book" do
    login_via_oauth
    visit book_url(@book)
    click_on "Destroy this book", match: :first

    assert_text "Book was successfully destroyed"
  end

  # Rainy day: unauthenticated user gets redirected to login
  test "unauthenticated user is redirected to login" do
    visit books_url
    assert_text "Log in to the Admin Dashboard"
  end
end
