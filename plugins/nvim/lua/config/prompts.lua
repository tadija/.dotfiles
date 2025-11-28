-- prompts used by plugins/ai.lua

-- VISUAL MODE ONLY

local advice = {
  strategy = "chat",
  description = "Get some special advice from an expert",
  opts = {
    short_name = "senior",
    modes = { "v" },
    auto_submit = true,
    stop_context_insertion = true,
    user_prompt = true,
  },
  prompts = {
    {
      role = "system",
      content = function(context)
        return "I want you to act as an expert senior " .. context.filetype .. " developer. " ..
          "I will ask you specific questions and I want you to return concise explanations and codeblock examples."
      end,
    },
    {
      role = "user",
      content = function(context)
        local text = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
        return "I have the following code:\n\n```" .. context.filetype .. "\n" .. text .. "\n```\n\n"
      end,
      opts = {
        contains_code = true,
      },
    },
  },
}

local comment = {
  strategy = "inline",
  description = "Add meaningful minimal comments",
  opts = {
    short_name = "comment",
    modes = { "v" },
  },
  prompts = {
    {
      role = "user",
      content = [[
Add minimal, meaningful comments to the selected code.
Clarify intent, assumptions, and non-obvious logic.
Avoid obvious or redundant comments.
Output code only.
      ]],
    },
  },
}

local extract = {
  strategy = "inline",
  description = "Extract smaller, well-named functions",
  opts = {
    short_name = "extract",
    modes = { "v" },
  },
  prompts = {
    {
      role = "user",
      content = [[
Refactor the selected code into smaller, well-named functions.
Preserve behavior, reduce complexity, and lower cognitive load.
Output code only.
      ]],
    },
  },
}

local idiomatize = {
  strategy = "inline",
  description = "Make code idiomatic for its language",
  opts = {
    short_name = "idiomatize",
    modes = { "v" },
  },
  prompts = {
    {
      role = "user",
      content = [[
Rewrite the selected code in an idiomatic style for its language.
Use clean patterns, built-ins, and common conventions.
Preserve behavior. Output code only.
      ]],
    },
  },
}

local optimize = {
  strategy = "inline",
  description = "Safe micro-optimizations",
  opts = {
    short_name = "optimize",
    modes = { "v" },
  },
  prompts = {
    {
      role = "user",
      content = [[
Optimize the selected code safely.
Allow micro-optimizations only: reduce allocations, simplify expressions,
remove dead branches, and tighten loops. Keep behavior identical.
Output code only.
      ]],
    },
  },
}

local refactor = {
  strategy = "inline",
  description = "Rewrite code with clean modern vibes",
  opts = {
    short_name = "refactor",
    modes = { "v" },
  },
  prompts = {
    {
      role = "user",
      content = [[
Rewrite or refactor the selected code in a clean, elegant, modern style.
Improve naming, structure, readability, and flow while preserving behavior.
Output code only.
      ]],
    },
  },
}

local simplify = {
  strategy = "inline",
  description = "Improve readability with minimal changes",
  opts = {
    short_name = "simplify",
    modes = { "v" },
  },
  prompts = {
    {
      role = "user",
      content = [[
Simplify and improve readability of the selected code with minimal and safe changes.
Focus on names, clarity, removing noise, and flattening structure.
Do NOT change behavior. Output code only.
      ]],
    },
  },
}

-- NORMAL + VISUAL

local explain = {
  strategy = "chat",
  description = "Explain selected code concisely",
  opts = {
    short_name = "explain",
    modes = { "n", "v" },
  },
  prompts = {
    {
      role = "user",
      content = [[
Explain the code (selected text, or the surrounding context if nothing selected).
Be concise, technical, and accurate. Highlight behavior, assumptions, and pitfalls.
Do NOT rewrite or modify the code.
      ]],
    },
  },
}

local review = {
  strategy = "chat",
  description = "Review for bugs, flaws, and edge cases",
  opts = {
    short_name = "rvw",
    modes = { "n", "v" },
  },
  prompts = {
    {
      role = "user",
      content = [[
Review the code (selection or context) for bugs, logical flaws, edge cases,
and incorrect assumptions. List potential issues clearly and concisely.
Suggest safe improvements, but do NOT rewrite the code.
      ]],
    },
  },
}

local vibe = {
  strategy = "inline",
  description = "Professional vibe coding assistant",
  opts = {
    short_name = "vibe",
    modes = { "n", "v" },
    is_slash_cmd = true,
    auto_submit = true,
    user_prompt = true,
  },
  prompts = {
    {
      role = "user",
      content = [[
If user input is empty:
- If no code is selected generate a short snippet in the context of the current buffer and get the vibe going. 
- Otherwise, transform the selected code into a better version of it, while following the vibe of the context.

else:
- Respect user input and do as asked (selection or context) - but with good vibes only.

In both cases: Output code only. Vibe code only.
      ]],
    },
  },
}

-- enabled prompts
return {
  -- v
  ["Advice"] = advice,
  ["Comment"] = comment,
  ["Extract"] = extract,
  ["Idiomatize"] = idiomatize,
  ["Optimize"] = optimize,
  ["Refactor"] = refactor,
  ["Simplify"] = simplify,
  -- n + v
  ["Explain"] = explain,
  ["Review"] = review,
  ["Vibe"] = vibe,
}
