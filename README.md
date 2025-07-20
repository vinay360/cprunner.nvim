# ⚡ cprunner.nvim

A lightweight, zero-dependency Neovim plugin for competitive programmers and C/C++ developers who want to compile and run their code instantly.

![GitHub stars](https://img.shields.io/github/stars/vinay360/cprunner.nvim?style=for-the-badge&logo=github&color=C9CBFF&logoColor=D9E0EE&labelColor=302D41)
![GitHub issues](https://img.shields.io/github/issues/vinay360/cprunner.nvim?style=for-the-badge&logo=github&color=F2CDCD&logoColor=D9E0EE&labelColor=302D41)

---

`cprunner.nvim` streamlines your C/C++ workflow by providing a single command to compile the current file and run it in a split terminal. It intelligently detects if an `input.txt` file has content and runs the program accordingly i.e either with file redirection or in interactive mode.


<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/5ac4b3ae-ca24-49df-8974-4bc8ed0600db" />


## ✨ Features

-   **One-Key Operation**: Compile and run your C/C++ file with a single keypress.
-   **Intelligent Input Handling**:
    -   If `input.txt` has content, it's automatically used as stdin.
    -   If `input.txt` is empty, the program runs in interactive mode.
-   **Smart Layout**: Automatically creates a vertical split for `input.txt` and a horizontal split for the terminal, then returns focus to your code.
-   **Configurable**: Easily change the compiler, flags, keymaps, and input file name.
-   **Lightweight & Fast**: No dependencies, just pure Lua.
-   **Clean Workspace**: Automatically closes the previous runner terminal on each new run.

## 📋 Requirements

-   Neovim >= 0.7.0

## 🚀 Installation

Install with your favorite plugin manager. Here is an example using `lazy.nvim`:

```lua
-- lua/plugins/cprunner.lua
return {
  "vinay360/cprunner.nvim",
  -- You can optionally configure it here
  opts = {
    -- your custom options
  }
}
```

## ⚙️ Configuration

`cprunner.nvim` works out of the box with sensible defaults, but you can customize every aspect of it.

### Default Configuration

Here are the default settings. You only need to specify the values you want to change in your `opts` table.

```lua
-- lua/plugins/cprunner.lua
return {
  "vinay360/cprunner.nvim",
  opts = {
    -- The compiler to use, e.g., "g++" or "clang++".
    compiler = "clang++",

    -- Default compiler flags for C++ and C.
    cpp_flags = { "-std=c++17", "-Wall", "-Wextra", "-O2" },
    c_flags = { "-std=c11", "-Wall", "-Wextra", "-O2" },

    -- The name of the input file to look for.
    input_filename = "input.txt",

    -- Whether to automatically set up the default keymap.
    setup_keymap = true,

    -- The default keymap to trigger the run function.
    keymap = "<F5>",
  }
}
```

### Customization Examples

#### Example 1: Use `g++` and a different keymap

```lua
-- lua/plugins/cprunner.lua
return {
  "vinay360/cprunner.nvim",
  opts = {
    compiler = "g++",
    keymap = "<leader>r",
  }
}
```

#### Example 2: Use modern C++20 flags

```lua
-- lua/plugins/cprunner.lua
return {
  "vinay360/cprunner.nvim",
  opts = {
    cpp_flags = { "-std=c++20", "-Wall", "-Wextra", "-g" }, -- Add debug symbols
  }
}
```

#### Example 3: Define your own keymap

If you prefer to manage all your keymaps in one place, you can disable the default and create your own.

```lua
-- lua/plugins/cprunner.lua
return {
  "vinay360/cprunner.nvim",
  -- Disable the default keymap
  opts = {
    setup_keymap = false,
  },
  -- Use the config function to set your own keymap
  config = function(_, opts)
    require("cprunner").setup(opts)

    -- Your custom keymap
    vim.keymap.set("n", "<leader>rr", require("cprunner").run, {
      desc = "Compile and Run C/C++ File [CPRunner]",
      noremap = true,
      silent = true,
    })
  end,
}
```

## 💡 Usage

The workflow is simple:

1.  Open your `.c` or `.cpp` file.
2.  (Optional) Add test case input to the `input.txt` file in the same directory.
3.  Press the configured keymap (`<F5>` by default).

-   **If `input.txt` has content**: The plugin will compile your code and run the executable, feeding `input.txt` as standard input. The terminal will wait for a keypress before closing.
-   **If `input.txt` is empty or does not exist**: The plugin will compile your code and run the executable in an interactive terminal session, waiting for your input.

The layout will be automatically managed for you, so you can focus on solving the problem.

---

*Made with ❤️ and Lua*
