defmodule DomainsCounterExWeb.DomainControllerTest do
  use DomainsCounterExWeb.ConnCase

  @create_attrs [0, "ya.ru", 42, "elixir-lang.org", 99, "google.com"]

  setup %{conn: conn} do
    {:ok, _} = Redix.command(:redix, ["FLUSHALL"])
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "show_domains" do
    test "lists all domains without params", %{conn: conn} do
      conn = get(conn, Routes.domain_path(conn, :show_domains))
      assert conn.status == 400
    end

    test "lists all domains with invalid param `from`", %{conn: conn} do
      conn =
        get(
          conn,
          Routes.domain_path(conn, :show_domains),
          from: "invalid",
          to: "100"
        )

      assert conn.status == 400
    end

    test "lists all domains with invalid param `to`", %{conn: conn} do
      conn =
        get(
          conn,
          Routes.domain_path(conn, :show_domains),
          from: "0",
          to: "invalid"
        )

      assert conn.status == 400
    end

    test "lists all domains with valid params", %{conn: conn} do
      {:ok, _} = Redix.command(:redix, ["ZADD", "domains" | @create_attrs])

      conn =
        get(
          conn,
          Routes.domain_path(conn, :show_domains),
          from: "0",
          to: "42"
        )

      assert json_response(conn, 200) ==
               %{"domains" => ["ya.ru", "elixir-lang.org"], "status" => "ok"}

      conn =
        get(
          conn,
          Routes.domain_path(conn, :show_domains),
          from: "10",
          to: "42"
        )

      assert json_response(conn, 200) ==
               %{"domains" => ["elixir-lang.org"], "status" => "ok"}

      conn =
        get(
          conn,
          Routes.domain_path(conn, :show_domains),
          from: "43",
          to: "100"
        )

      assert json_response(conn, 200) ==
               %{"domains" => ["google.com"], "status" => "ok"}

      conn =
        get(
          conn,
          Routes.domain_path(conn, :show_domains),
          from: "100",
          to: "1000"
        )

      assert json_response(conn, 200) ==
               %{"domains" => [], "status" => "ok"}
    end
  end

  describe "save_links" do
    test "save no links", %{conn: conn} do
      conn =
        post(
          conn,
          Routes.domain_path(conn, :save_links),
          %{links: ["ya.ru", "google.com", "funbox.ru"]}
        )

      assert conn.status == 200

      ts = DateTime.utc_now() |> DateTime.to_unix() |> Integer.to_string()

      {:ok, result} =
        Redix.command(
          :redix,
          ["ZRANGEBYSCORE", "domains", "-inf", "+inf", "WITHSCORES"]
        )

      assert result == ["funbox.ru", ts, "google.com", ts, "ya.ru", ts]
    end
  end
end
