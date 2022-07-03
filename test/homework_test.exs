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

  test "able to add and remove elements" do
    try do
      IO.puts("navigate to add/remove page")
      url = "https://the-internet.herokuapp.com/add_remove_elements/"
      navigate_to(url)
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
    rescue
      error ->
        HomeworkTest.error_screenshot("add_remove_elements")
        raise error
    end
  end

  test "login page" do
    try do
      IO.puts("navigate to login page")
      url = "https://the-internet.herokuapp.com/login"
      navigate_to(url)
      assert {:ok, login_form} = search_element(:id, "login")
      IO.puts("invalid credentials")
      username = find_within_element(login_form, :id, "username")
      password = find_within_element(login_form, :id, "password")
      submit = find_within_element(login_form, :tag, "button")
      username |> fill_field("testusername")
      password |> fill_field("i'msocool")
      submit |> click()
      IO.puts("submit invalid creds")
      alert_container = find_element(:id, "flash")
      alert_text = String.trim(visible_text(alert_container), "\n×")
      assert alert_text == "Your username is invalid!"

      IO.puts("enter correct credentials")
      assert {:ok, login_form} = search_element(:id, "login")
      username = find_within_element(login_form, :id, "username")
      password = find_within_element(login_form, :id, "password")
      submit = find_within_element(login_form, :tag, "button")
      username |> fill_field("tomsmith")
      password |> fill_field("SuperSecretPassword!")
      IO.puts("submit correct credentials")
      submit |> click()
      alert_container = find_element(:id, "flash")
      alert_text = String.trim(visible_text(alert_container), "\n×")
      assert alert_text == "You logged into a secure area!"

      IO.puts("logout")
      logout = find_element(:link_text, "Logout")
      logout |> click()
      alert_container = find_element(:id, "flash")
      alert_text = String.trim(visible_text(alert_container), "\n×")
      assert alert_text == "You logged out of the secure area!"
    rescue
      error ->
        HomeworkTest.error_screenshot("login_screen")
        raise error
    end
  end
end
