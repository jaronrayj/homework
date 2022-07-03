defmodule HomeworkTest do
  # Import helpers
  use Hound.Helpers
  use ExUnit.Case

  # Start hound session and destroy when tests are run
  hound_session()

  # todo add error screenshot process?

  def error_screenshot(file_path) do
    error_file_path = "err_#{file_path}.png"
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
end
