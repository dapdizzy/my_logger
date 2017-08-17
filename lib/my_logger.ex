defmodule MyLogger do
  @moduledoc """
  Documentation for MyLogger.
  """

  use GenServer

  # Server callbacks
  def init([filename]) do
    file_handle = filename |> File.open!([:append, :utf8, :write])
    {:ok, file_handle}
  end

  def handle_cast({:log, message}, file_handle) do
    {{year, month, day}, {hour, minute, second}} = :calendar.local_time()
    timestamp = ~s|#{day |> rfix(2, "0")}.#{month |> rfix(2, "0")}.#{year |> rfix(2, "0")} #{hour |> rfix(2, "0")}:#{minute |> rfix(2, "0")}:#{second |> rfix(2, "0")}|
    file_handle |> IO.puts("#{timestamp} :: #{message}\r\n")
    {:noreply, file_handle}
  end

  # API

  def start_link(filename, logger_alias \\ __MODULE__) do
    GenServer.start_link(__MODULE__, [filename], name: logger_alias)
  end

  def log(logger_alias \\ __MODULE__, message) do
    logger_alias |> GenServer.cast({:log, message})
  end

  # Helpers
  defp rfix(char_value, length, pad_string) do
    "#{char_value}" |> String.pad_leading(length, pad_string)
  end

end
