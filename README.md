# Tamiz's epic nvim config B)

## Current features
- Highlight text on yank
- Treesitter
- Mason + LSP support
- Diagnostics
- Autocomplete w/ blink.cmp
- cool colour theme (onedark)
- format on save via conform
- template .editorconfig and .clang-format files that are symlinked on startup
- IBL scope lines
- custom status line (very premium look)
- diagnostic quickfix list
- persistence via mini.sessions
- fuzzy finding with mini.pick

## TODOs
- [x] solve issues with `#include`s and `bits/stdc++.h`
    - `bits/stdc++.h` not recognised on macOS
    - specific `#include`s auto added even when `bits/stdc++.h` is already there
- [X] figure out macro stuff
- [ ] look into file trees
- [ ] implement mini.extra pickers
- [ ] look into mini.git and mini.diff to remove gitsigns
