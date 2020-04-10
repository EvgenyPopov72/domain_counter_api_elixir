defmodule DomainsCounterExWeb.ChangesetView do
  use DomainsCounterExWeb, :view

  @doc """
  Traverses and translates changeset errors.

  See `Ecto.Changeset.traverse_errors/2` and
  `DomainsCounterExWeb.ErrorHelpers.translate_error/1` for more details.
  """

  def render("error.json", %{changeset: changeset}) do
    # When encoded, the changeset returns its errors
    # as a JSON object. So we just pass it forward.
    %{errors: changeset}
  end
end
