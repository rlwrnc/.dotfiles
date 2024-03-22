local config = {
  signs = false,
  keywords = { 
    FIX = { icon = "#", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, },
    TODO = { icon = ">", color = "info" },
    HACK = { icon = "?", color = "warning" },
    WARN = { icon = "!", color = "warning", alt = { "WARNING", "XXX" } },
    PERF = { icon = ".", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
    NOTE = { icon = "i", color = "hint", alt = { "INFO" } },
    TEST = { icon = "T", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
  },
  highlight = {
    before = "",
    keyword = "bg",
    after = "",
    pattern = {
      [[.*(KEYWORDS)\s*:]],
      [[.*(KEYWORDS)(.*)\s*:]]
    },
  },
  search = {
    pattern = [[\b(KEYWORDS)(\(.*\))?:]]
  },
}

require('todo-comments').setup(config)
