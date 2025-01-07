local jdtls_opts = require('lsp-zero').build_options('jdtls', {})

local config = {
    cmd = {'/usr/local/bin/jdtls'},
    on_attach = jdtls_opts.on_attach,
    root_dir = vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw'}, { upward = true })[1]),
}

require('jdtls').start_or_attach(config)

