local auto_pairs = {
  ["{"] = "{}",
  ["("] = "()",
  ["["] = "[]",
  ['"'] = '""',
  ["'"] = "''",
}
for open, pair in pairs(auto_pairs) do
  vim.keymap.set("i", open, function()
    local col = vim.fn.col(".")
    local line = vim.fn.getline(".")
    local right = line:sub(col, col)

    if right == "" or right:match("%s") then
      return pair:sub(1, 1) .. pair:sub(2, 2) .. "<Left>"
    else
      return open
    end
  end, { expr = true })
end
