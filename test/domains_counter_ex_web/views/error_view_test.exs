defmodule DomainsCounterExWeb.ErrorViewTest do
  use DomainsCounterExWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 400.json" do
    assert render(DomainsCounterExWeb.ErrorView, "400.json", []) == %{
             errors: %{detail: "Bad Request"}
           }
  end

  test "custom renders 400.json" do
    assert render(
             DomainsCounterExWeb.ErrorView,
             "400.json",
             %{message: "Test Msg"}) ==
             %{status: "Bad Request", message: "Test Msg"}
  end

  test "renders 404.json" do
    assert render(DomainsCounterExWeb.ErrorView, "404.json", []) == %{
             errors: %{detail: "Not Found"}
           }
  end

  test "renders 500.json" do
    assert render(DomainsCounterExWeb.ErrorView, "500.json", []) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
