defmodule HomeworkTest do
  # Import helpers
  use Hound.Helpers
  use ExUnit.Case

  # Start hound session and destroy when tests are run
  hound_session()

  def error_screenshot(file_path) do
    error_file_path = "screenshots/err_#{file_path}.png"
    take_screenshot(error_file_path)
  end

  def fill_login_info(username_text, password_text) do
    assert {:ok, login_form} = search_element(:id, "login")
    username_field = find_within_element(login_form, :id, "username")
    password_field = find_within_element(login_form, :id, "password")
    submit_button = find_within_element(login_form, :tag, "button")
    username_field |> fill_field(username_text)
    password_field |> fill_field(password_text)
    submit_button |> click()
  end

  def verify_notification_message(message) do
    alert_container = find_element(:id, "flash")
    alert_text = String.trim(visible_text(alert_container), "\n×")
    assert alert_text == message
  end

  test "able to add and remove elements" do
    try do
      IO.puts("navigate to add/remove page")
      navigate_to("https://the-internet.herokuapp.com/add_remove_elements/")

      assert {:ok, button_container} = search_element(:class, "example")
      add_element_button = find_within_element(button_container, :tag, "button")
      delete_array = find_element(:id, "elements")

      IO.puts("verify no delete elements first")
      assert {:error, _} = search_element(:class, "added-manually")

      IO.puts("click button to add element")
      add_element_button |> click()

      IO.puts("click delete button to remove element")
      delete_button = find_within_element(delete_array, :class, "added-manually")
      delete_button |> click()
      IO.puts("---------END TEST-----------")
    rescue
      error ->
        HomeworkTest.error_screenshot("add_remove_elements")
        raise error
    end
  end

  test "login process" do
    try do
      IO.puts("navigate to login page")
      navigate_to("https://the-internet.herokuapp.com/login")

      IO.puts("submit invalid creds")
      HomeworkTest.fill_login_info("testusername", "i'msocool")
      HomeworkTest.verify_notification_message("Your username is invalid!")

      IO.puts("submit correct credentials")
      HomeworkTest.fill_login_info("tomsmith", "SuperSecretPassword!")
      HomeworkTest.verify_notification_message("You logged into a secure area!")

      IO.puts("logout")
      logout = find_element(:link_text, "Logout")
      logout |> click()
      HomeworkTest.verify_notification_message("You logged out of the secure area!")

      IO.puts("---------END TEST-----------")
    rescue
      error ->
        HomeworkTest.error_screenshot("login_screen")
        raise error
    end
  end

  test "able to verify hover functionality" do
    try do
      IO.puts("navigate to hover page")
      navigate_to("https://the-internet.herokuapp.com/hovers")

      IO.puts("hover over picture")
      assert {:ok, image_container} = search_element(:class, "figure")
      move_to(image_container, 10, 10)

      IO.puts("verify name is in correct format")
      user_name_element = find_within_element(image_container, :tag, "h5")
      user_text = visible_text(user_name_element)
      assert true = String.contains?(user_text, "name:")

      IO.puts("navigate to user profile")
      profile_link = find_within_element(image_container, :tag, "a")
      profile_link |> click()
      # if link took to actual URL could verify that user name matched up
      IO.puts("---------END TEST-----------")
    rescue
      error ->
        HomeworkTest.error_screenshot("hover")
        raise error
    end
  end
end
