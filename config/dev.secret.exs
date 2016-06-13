use Mix.Config

config :exredis,
    host: "104.131.71.248",
    port: 6379,
    password: "013723591f1c7e6d5933d68ca4aaa9fa8511254a22ce7fc8863f42baa3bf4f5c",
    db: 0,
    reconnect: :no_reconnect,
    max_queue: :infinity
