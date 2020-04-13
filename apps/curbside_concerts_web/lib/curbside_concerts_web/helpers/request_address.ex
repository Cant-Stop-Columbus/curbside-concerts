defmodule CurbsideConcertsWeb.Helpers.RequestAddress do

  alias CurbsideConcerts.Requests.Request
  @moduledoc """

  This holds the logic to concatendate the address fields in a Request for viewing purposes
  If the legacy nominee_address field exists in the Request, this method will return that value
  
  ## Example
  ```
  request = %Request{
   nominee_street_address: "80 E Rich St.",
   nominee_city: "Columbus",
   moninee_zip_code: "43215"
  }

  full_address(request)
  ```

  Results in:

  ```
  "80 E Rich St. Columbus 43215"
  ```
  """

  def full_address(%Request{
    nominee_address: nominee_address,
    nominee_street_address: nominee_street_address,
    nominee_city: nominee_city,
    nominee_zip_code: nominee_zip_code
  }) do 
    cond do
      nominee_address -> nominee_address
      true -> "#{nominee_street_address} #{nominee_city} #{nominee_zip_code}"
    end
  end
end
