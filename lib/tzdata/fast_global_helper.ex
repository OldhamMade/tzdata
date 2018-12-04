
defmodule FastGlobalHelper do


  #-------------------
  # sync_record
  #-------------------
  def sync_record(identifier, default) do
    value = if is_function(default, 0) do
      default.()
    else
      default
    end

    if Semaphore.acquire({:fg_helper_write_record, identifier}, 1) do
      case value do
        {:fast_global, :no_cache, _} -> :skip
        v -> FastGlobal.put(identifier, value)
      end
      Semaphore.release({:fg_helper_write_record, identifier})
    end

    case value do
      {:fast_global, :no_cache, v} -> v
      _ ->
        value
    end
  end

  #-------------------
  # get
  #-------------------
  def get(identifier, default \\ {:fast_global, :no_cache, nil}) do
    case FastGlobal.get(identifier, :fg_helper_no_match) do
      :fg_helper_no_match -> sync_record(identifier, default)
      v -> v
    end
  end

  defdelegate put(identifier, value), to: FastGlobal

end