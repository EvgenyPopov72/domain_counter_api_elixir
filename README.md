# Описание

WEB-приложение для для простого учета посещенных ссылок. Представляет собой HTTP JSON API. Предоставляет два эндпойнта:

    POST /visited_links для загрузки посещений.
    GET /visited_domains?from=1545221231&to=1545217638 для получения статистики.

# Для работы требуются следующие компоненты:
  * [Redis server](https://redis.io/)
  * [Erlang](https://www.erlang.org/)
  * [Elixir](https://elixir-lang.org/)

# Для запуска нужно выполнить:
  * Установим зависимости `mix deps.get`
  * Запустим Phoenix сервер `mix phx.server`

API доступен на: [`localhost:4000`](http://localhost:4000).
