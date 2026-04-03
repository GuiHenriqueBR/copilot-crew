---
name: elixir-patterns
description: "Elixir idioms, Phoenix/LiveView patterns, OTP, and testing with ExUnit. Load for Elixir code."
---

# Elixir Patterns Skill

## Key Idioms

### Pattern Matching & Guards
```elixir
def handle_response({:ok, %{status: 200, body: body}}), do: {:ok, Jason.decode!(body)}
def handle_response({:ok, %{status: 404}}), do: {:error, :not_found}
def handle_response({:ok, %{status: status}}) when status >= 500, do: {:error, :server_error}
def handle_response({:error, reason}), do: {:error, reason}
```

### Pipe Operator
```elixir
user
|> Map.put(:name, String.trim(user.name))
|> validate_email()
|> hash_password()
|> Repo.insert()
|> case do
  {:ok, user} -> {:ok, UserResponse.from(user)}
  {:error, changeset} -> {:error, format_errors(changeset)}
end
```

### With Expression (happy path)
```elixir
def create_order(params) do
  with {:ok, user} <- find_user(params.user_id),
       {:ok, items} <- validate_items(params.items),
       {:ok, payment} <- charge_payment(user, total(items)),
       {:ok, order} <- Repo.insert(Order.changeset(%Order{}, params)) do
    {:ok, order}
  else
    {:error, :user_not_found} -> {:error, "User not found"}
    {:error, :insufficient_funds} -> {:error, "Payment failed"}
    {:error, changeset} -> {:error, format_errors(changeset)}
  end
end
```

### GenServer (stateful process)
```elixir
defmodule MyApp.Cache do
  use GenServer

  def start_link(opts), do: GenServer.start_link(__MODULE__, %{}, opts)
  def get(pid, key), do: GenServer.call(pid, {:get, key})
  def put(pid, key, value), do: GenServer.cast(pid, {:put, key, value})

  @impl true
  def init(state), do: {:ok, state}

  @impl true
  def handle_call({:get, key}, _from, state), do: {:reply, Map.get(state, key), state}

  @impl true
  def handle_cast({:put, key, value}, state), do: {:noreply, Map.put(state, key, value)}
end
```

## Phoenix / LiveView

### Context (bounded context pattern)
```elixir
defmodule MyApp.Accounts do
  def create_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def get_user!(id), do: Repo.get!(User, id)

  def list_active_users do
    User
    |> where([u], u.status == :active)
    |> order_by([u], u.name)
    |> Repo.all()
  end
end
```

### LiveView
```elixir
defmodule MyAppWeb.UserListLive do
  use MyAppWeb, :live_view

  def mount(_params, _session, socket) do
    users = Accounts.list_active_users()
    {:ok, assign(socket, users: users, search: "")}
  end

  def handle_event("search", %{"query" => query}, socket) do
    users = Accounts.search_users(query)
    {:noreply, assign(socket, users: users, search: query)}
  end

  def render(assigns) do
    ~H"""
    <.input type="text" name="query" value={@search} phx-change="search" placeholder="Search..." />
    <ul :for={user <- @users}>
      <li><%= user.name %> — <%= user.email %></li>
    </ul>
    """
  end
end
```

## Testing (ExUnit)
```elixir
defmodule MyApp.AccountsTest do
  use MyApp.DataCase, async: true

  describe "create_user/1" do
    test "creates user with valid data" do
      attrs = %{name: "Alice", email: "alice@test.com", password: "secret123"}
      assert {:ok, user} = Accounts.create_user(attrs)
      assert user.name == "Alice"
      assert user.email == "alice@test.com"
    end

    test "rejects duplicate email" do
      attrs = %{name: "Alice", email: "dup@test.com", password: "secret123"}
      assert {:ok, _} = Accounts.create_user(attrs)
      assert {:error, changeset} = Accounts.create_user(attrs)
      assert "has already been taken" in errors_on(changeset).email
    end
  end
end
```
