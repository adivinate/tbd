alias Plustwo.Infrastructure.Repo.Postgres
alias Plustwo.Domain.World

File.stream!("priv/postgres/data/currencies.csv")
|> CSV.decode()
|> Enum.each(fn currency -> case currency do
                 {:ok, currency_info} ->
                   [currency_name, currency_code] = currency_info
                   World.get_currency_by_code(currency_code) ||
                     World.create_currency(%{
                                             code: currency_code,
                                             name: currency_name,
                                           })

                 _ ->
                   raise "Skipped #{currency}"
               end end)
File.stream!("priv/postgres/data/locales.csv")
|> CSV.decode()
|> Enum.each(fn locale -> case locale do
                 {:ok, locale_info} ->
                   [locale_code, locale_name] = locale_info
                   World.get_locale_by_code(locale_code) ||
                     World.create_locale(%{
                                           code: locale_code,
                                           name: locale_name,
                                         })

                 _ ->
                   raise "Skipped #{locale}"
               end end)
File.stream!("priv/postgres/data/countries.csv")
|> CSV.decode()
|> Enum.each(fn country -> case country do
                 {:ok, country_info} ->
                   [country_code, country_name] = country_info
                   World.get_country_by_code(country_code) ||
                     World.create_country(%{
                                            code: country_code,
                                            name: country_name,
                                          })

                 _ ->
                   raise "Skipped #{country}"
               end end)
File.stream!("priv/postgres/data/zones.csv")
|> CSV.decode()
|> Enum.each(fn zone -> case zone do
                 {:ok, zone_info} ->
                   IO.inspect zone_info
                   [_, country_code, zone_name] = zone_info
                   case World.get_zone_by_name(zone_name) do
                     nil ->
                       case World.get_country_by_code(country_code) do
                         country ->
                           World.create_zone %{
                                               country_id: country.id,
                                               name: zone_name,
                                             }

                         _ ->
                           raise "Uhuh, unable to find country for #{country_code} #{zone_name}"
                       end

                     _ ->
                       raise "Zone already exists"
                   end

                 _ ->
                   raise "Skipped #{zone}"
               end end)
File.stream!("priv/postgres/data/timezones.csv")
|> CSV.decode()
|> Enum.each(fn tz -> case tz do
                 {:ok, tz_info} ->
                   [
                       tz_zone_id,
                       tz_abbr,
                       tz_time_start,
                       tz_gmt_offeset,
                       tz_dst,
                     ] =
                     tz_info
                   case Postgres.get_by(World.Timezone,
                                        zone_id: tz_zone_id,
                                        abbreviation: tz_abbr,
                                        time_start: tz_time_start,
                                        gmt_offset: tz_gmt_offeset,
                                        dst: tz_dst) do
                     nil ->
                       case Postgres.get_by(World.Zone, id: tz_zone_id) do
                         zone ->
                           World.create_timezone %{
                                                   zone_id: zone.id,
                                                   abbreviation: tz_abbr,
                                                   time_start: tz_time_start,
                                                   gmt_offset: tz_gmt_offeset,
                                                   dst: tz_dst,
                                                 }

                         _ ->
                           raise "Uhuh, unable to find zone for #{tz_zone_id} #{tz_abbr} #{tz_time_start}"
                       end

                     _ ->
                       raise "Timezone already exists"
                   end

                 _ ->
                   raise "Skipped #{tz}"
               end end)
