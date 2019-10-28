defmodule Generic do 

    def generate_id(value) do
        :crypto.hash(:sha, value)|>Base.encode16
      end

end