locals {
  current_timestamp = timestamp()
  formatted_date = formatdate("DD-MM-YYYY", local.current_timestamp)
  bucket_name = "kirkhkesler-${local.formatted_date}"
}