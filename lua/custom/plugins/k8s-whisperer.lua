return {
  "manzanit0/k8s-whisper.nvim",
  config = function()
    require('k8s-whisper').setup({
        -- This is a GitHub repository
        schemas_catalog = 'datreeio/CRDs-catalog',
        -- This is a git ref, branch, tag, sha, etc.
        schema_catalog_ref = 'main',
    })
  end
}
