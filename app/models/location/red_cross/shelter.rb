class Location
  module RedCross
    class Shelter < Location

      # Import, Models, HTML Controller, API Controller
      config(
        legacy_table_name: "shelters",
        organization: "red-cross"
      )

      filter(:status)
      filter(:notes)

      legacy_field(:status, type: :enum, options: ["Open", "Full", "Closed"])
      legacy_field(:population)
      legacy_field(:notes)
      legacy_field(:private_notes, admin_only: true)
    end
  end
end
