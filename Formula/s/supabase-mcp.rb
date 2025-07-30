class SupabaseMcp < Formula
  desc "MCP Server for Supabase"
  homepage "https://supabase.com/docs/guides/getting-started/mcp"
  url "https://registry.npmjs.org/@supabase/mcp-server-supabase/-/mcp-server-supabase-0.4.5.tgz"
  sha256 "8b6aa29dbfdd6b719cda7836920f322f07a2820bf486a9d89e855b7d01ea38ad"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "543c54f3b6141372c7fa6c72768c69713211745a29b844ef3e229cf6a2d8e1b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d305114f8bd1e7c1ffb577577cb8aec3f13926acc93ec8c0b1dce9e5ddfcee29"
    sha256 cellar: :any_skip_relocation, ventura:       "542b13432abedc65ac44fc6c4fbe63fa265698db1830692710b4a5c4b661f6cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9aa6fc164aa5c2ecb5bbef64f0b3283b65e627ae23ccb4b87fe8fcbe3537c8a6"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcp-server-supabase --version")

    ENV["SUPABASE_ACCESS_TOKEN"] = "test-token"

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    assert_match "Lists all Supabase projects for the user", pipe_output(bin/"mcp-server-supabase", json, 0)
  end
end
