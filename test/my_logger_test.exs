defmodule MyLoggerTest do
  use ExUnit.Case
  doctest MyLogger

  test "the truth" do
    assert 1 + 1 == 2
  end

  test "under pressure" do
    loggerName = YouLogger
    {:ok, _pid} = MyLogger.start_link("C:/Txt/YouLogger8.txt", loggerName)
    1..100
      |> Enum.map(fn process_number ->
        Task.async(fn ->
          1..Enum.random(1..1000)
            |> Enum.each(fn counter ->
              message = "#{counter} message from #{process_number} #{inspect self}"
              # IO.puts message
              loggerName |> MyLogger.log(message)
            end)
        end)
      end)
      |> Enum.each(&Task.await/1)
      # |> Enum.each(fn task -> task |> Task.await end)
    Process.sleep(10_000) # Let the Logger process enough time to drain the logging queue
    IO.puts "Done!"
    assert true
  end
end
