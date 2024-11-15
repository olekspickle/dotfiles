require("codesnap").setup({
    -- The save_path must be ends with .png, unless when you specified a directory path,
    -- CodeSnap will append an auto-generated filename to the specified directory path
    save_path = "~/Pictures/codesnap",
    parsed = "~/Pictures/codesnap/saved_y-m-d_at_h:m:s.png",
    has_breadcrumbs = true,
    breadcrumbs_separator = "->",
    bg_theme = "grape",
    watermark = "olekspickle",
    watermark_font_family = "JetBrains Mono",
    -- mac_window_bar = true,
    -- title = "CodeSnap.nvim",
    -- code_font_family = "CaskaydiaCove Nerd Font",
})
