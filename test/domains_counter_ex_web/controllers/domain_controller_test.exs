defmodule DomainsCounterExWeb.DomainControllerTest do
  use DomainsCounterExWeb.ConnCase

  alias DomainsCounterEx.Domains
  alias DomainsCounterEx.Domains.Domain

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:domain) do
    {:ok, domain} = Domains.create_domain(@create_attrs)
    domain
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all domains", %{conn: conn} do
      conn = get(conn, Routes.domain_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create domain" do
    test "renders domain when data is valid", %{conn: conn} do
      conn = post(conn, Routes.domain_path(conn, :create), domain: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.domain_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.domain_path(conn, :create), domain: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update domain" do
    setup [:create_domain]

    test "renders domain when data is valid", %{conn: conn, domain: %Domain{id: id} = domain} do
      conn = put(conn, Routes.domain_path(conn, :update, domain), domain: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.domain_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, domain: domain} do
      conn = put(conn, Routes.domain_path(conn, :update, domain), domain: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete domain" do
    setup [:create_domain]

    test "deletes chosen domain", %{conn: conn, domain: domain} do
      conn = delete(conn, Routes.domain_path(conn, :delete, domain))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.domain_path(conn, :show, domain))
      end
    end
  end

  defp create_domain(_) do
    domain = fixture(:domain)
    {:ok, domain: domain}
  end
end
