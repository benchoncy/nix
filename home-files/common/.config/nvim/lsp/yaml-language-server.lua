---@type vim.lsp.Config
return {
    cmd = { "yaml-language-server", "--stdio" },
    filetypes = { "yaml" },
    settings = {
        yaml = {
            hover = true,
            validate = true,
            completion = true,
            keyOrdering = false,
            format = { enabled = false },
            redhat = {
                telemetry = { enabled = false },
            },
            schemaStore = {
                enable = true,
                url = "https://www.schemastore.org/api/json/catalog.json",
            },
            schemas = {
                ["https://www.schemastore.org/github-workflow"] = { ".github/workflows/*" },
                ["https://www.schemastore.org/github-action"] = { ".github/action.{yml,yaml}" },
                ["https://raw.githubusercontent.com/aws/serverless-application-model/main/samtranslator/schema/schema.json"] = {
                    "sam.{yml,yaml}",
                    "*.sam.{yml,yaml}",
                    "template.sam.{yml,yaml}",
                    "template-sam.{yml,yaml}",
                },
                ["https://raw.githubusercontent.com/awslabs/goformation/master/schema/cloudformation.schema.json"] = {
                    "cloudformation.{yml,yaml}",
                    "*.cloudformation.{yml,yaml}",
                    "*.cf.{yml,yaml}",
                    "template.{yml,yaml}",
                },
            },
            customTags = {
                "!And sequence",
                "!Base64 scalar",
                "!Cidr sequence",
                "!Condition scalar",
                "!Equals sequence",
                "!FindInMap sequence",
                "!GetAtt scalar",
                "!GetAtt sequence",
                "!GetAZs scalar",
                "!If sequence",
                "!ImportValue scalar",
                "!Join sequence",
                "!Not sequence",
                "!Or sequence",
                "!Ref scalar",
                "!Select sequence",
                "!Split sequence",
                "!Sub scalar",
                "!Sub sequence",
                "!Transform mapping",
            },
        },
    },
}
