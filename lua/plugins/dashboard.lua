-- Function to get image dimensions
local function get_image_dimensions(image_path)
  local handle = io.popen(string.format("identify -format '%%w %%h' '%s' 2>/dev/null", image_path))
  if handle then
    local result = handle:read("*a")
    handle:close()
    local width, height = result:match("(%d+) (%d+)")
    if width and height then
      return tonumber(width), tonumber(height)
    end
  end
  return nil, nil
end

-- Function to generate images from a folder and save to cache file
local function generate_dashboard_images()
  local image_folder = vim.fn.expand("~/Documents/dashboard-pics/") -- Change this to your image folder
  local images = vim.fn.glob(image_folder .. "/*.{png,jpg,jpeg,gif}", false, true)

  local cache = {}
  for _, image_path in ipairs(images) do
    -- Get image dimensions to determine aspect ratio
    local width, height = get_image_dimensions(image_path)
    local chafa_size = "60x17" -- Default for horizontal/square

    if width and height then
      local aspect_ratio = width / height
      if aspect_ratio < 0.8 then
        -- Vertical image - use taller size
        chafa_size = "50x35"
      elseif aspect_ratio > 1.5 then
        -- Wide horizontal - use wider size
        chafa_size = "70x15"
      end
    end

    local temp_file = "/tmp/chafa_temp_" .. os.time() .. math.random(1000) .. ".txt"
    -- Generate chafa output to temp file to preserve colors
    os.execute(
      string.format(
        "chafa '%s' --format symbols --symbols vhalf --size %s --stretch > %s",
        image_path,
        chafa_size,
        temp_file
      )
    )

    local file = io.open(temp_file, "r")
    if file then
      local result = file:read("*a")
      file:close()
      os.remove(temp_file)

      if result and result ~= "" then
        -- Store with metadata about size
        cache[#cache + 1] = {
          image = result,
          size = chafa_size,
          name = vim.fn.fnamemodify(image_path, ":t"),
        }
        print(string.format("Generated image %d: %s (%s)", #cache, vim.fn.fnamemodify(image_path, ":t"), chafa_size))
      end
    end
  end

  -- Save to cache file
  local cache_file = vim.fn.stdpath("config") .. "/lua/dashboard_image_cache.lua"
  local file = io.open(cache_file, "w")
  if file then
    file:write("-- Auto-generated dashboard image cache\n")
    file:write("-- Generated on " .. os.date() .. "\n")
    file:write("return {\n")
    for i, data in ipairs(cache) do
      -- Save as table with metadata
      file:write(string.format("  [%d] = {\n", i))
      file:write(string.format("    image = %q,\n", data.image))
      file:write(string.format("    size = %q,\n", data.size))
      file:write(string.format("    name = %q,\n", data.name))
      file:write("  },\n")
    end
    file:write("}\n")
    file:close()
    print("\nSaved " .. #cache .. " images to " .. cache_file)
  else
    print("Error: Could not write to cache file")
  end

  return cache
end

-- Load cached images
local image_cache = {}
local ok, cached = pcall(require, "dashboard_image_cache")
if ok then
  image_cache = cached
end

-- Function to get a random cached image
local function get_random_image()
  if #image_cache == 0 then
    return { image = "No images cached. Run :DashboardGenerateImages first.", height = 17 }
  end
  math.randomseed(os.time())
  local selected = image_cache[math.random(#image_cache)]

  -- Handle both old format (string) and new format (table)
  if type(selected) == "string" then
    return { image = selected, height = 17 }
  else
    -- Extract height from size string (e.g., "60x17" -> 17)
    local height = tonumber(selected.size:match("x(%d+)")) or 17
    return { image = selected.image, height = height }
  end
end

-- Create the keybind command
vim.api.nvim_create_user_command("DashboardGenerateImages", function()
  generate_dashboard_images()
  -- Reload the cache
  package.loaded["dashboard_image_cache"] = nil
  local ok, cached = pcall(require, "dashboard_image_cache")
  if ok then
    image_cache = cached
    print("Cache reloaded. Restart nvim to see new images.")
  end
end, {})

return {
  {
    "snacks.nvim",
    opts = {
      -- get a random image from cache
      image_data = get_random_image(),
      scroll = { enabled = false },
      dashboard = {
        enabled = true,
        sections = {
          {
            section = "terminal",
            cmd = "echo " .. vim.fn.shellescape(get_random_image().image),
            height = get_random_image().height,
            padding = 1,
          },
          {
            pane = 2,
            {
              section = "keys",
              gap = 1,
              padding = 1,
              items = {
                { action = "lua LazyVim.pick()()", desc = "Find File", icon = " ", key = "f" },
                { action = "lua LazyVim.pick.config_files()()", desc = "Config", icon = " ", key = "c" },
                { action = "lua OpenNotes()", desc = "Notes", icon = " ", key = "n" },
                { action = "lua OpenJournal()", desc = "Journal", icon = "󰦝 ", key = "m" },
                { action = 'lua require("persistence").load()', desc = "Restore Session", icon = " ", key = "s" },
                { action = ":LazyExtras", desc = "Lazy Extras", icon = " ", key = "x" },
                { action = ":Lazy", desc = "Lazy", icon = "󰒲 ", key = "l" },
                { action = ":qa", desc = "Quit", icon = " ", key = "q" },
              },
            },
            { section = "startup" },
          },
        },
      },
    },
  },
}