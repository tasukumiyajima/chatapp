json.array!(@emojis) do |emoji|
  json.value emoji.name
  json.url image_path("emoji/#{emoji.image_filename}")
end
