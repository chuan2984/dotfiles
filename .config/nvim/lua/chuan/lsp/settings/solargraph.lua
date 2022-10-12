return {
  cmd = { "docker", "exec", "-i", "fieldwire_web", "solargraph", "stdio" },
  settings = {
    solargraph = {
    --[[   transport = "external", ]]
    --[[   externalServer = { ]]
    --[[     host = "0.0.0.0", ]]
    --[[     port = 3000, ]]
    --[[   }, ]]
     autoformat = false,
     diagnostics = false,
    },
  }
}
