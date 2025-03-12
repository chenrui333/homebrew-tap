class Tfmcp < Formula
  desc "Terraform Model Context Protocol (MCP) Tool"
  homepage "https://github.com/nwiizo/tfmcp"
  url "https://github.com/nwiizo/tfmcp/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "d4c0f16992f89f6c45d66c34eea578ca8e91c08f1027941f326de345487e29ba"
  license "MIT"
  head "https://github.com/nwiizo/tfmcp.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tfmcp --version")

    output = shell_output("#{bin}/tfmcp analyze 2>&1")
    assert_match "Terraform analysis complete", output
    assert_match "Hello from tfmcp!", (testpath/"main.tf").read
  end
end
