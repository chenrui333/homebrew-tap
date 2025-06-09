class Tfmcp < Formula
  desc "Terraform Model Context Protocol (MCP) Tool"
  homepage "https://github.com/nwiizo/tfmcp"
  url "https://github.com/nwiizo/tfmcp/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "784c09b121bddf3a5bf393fb4991a3132cf096258bdc5bc05ac32a4b8e1fe0eb"
  license "MIT"
  head "https://github.com/nwiizo/tfmcp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "930e2090719a490c487c7899ae6e7e7feac0f99fc3bd0f4dd532069ca9cc5a26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a2b383a97bb81e06fec6b0a358b8538171228c2375b8729e8691dce85046713"
    sha256 cellar: :any_skip_relocation, ventura:       "ff1a911b7b5366c9ce91ee28d99c3d704f7133517d4ec51d7ebee4d4e0ece466"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f482e144076d0d098d058b50787c405a23fd8c6092708a24abe89f56d4af694b"
  end

  depends_on "rust" => :build
  depends_on "opentofu" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tfmcp --version")

    ENV["TERRAFORM_BINARY_NAME"] = "tofu"

    output = shell_output("#{bin}/tfmcp analyze 2>&1")
    assert_match "Terraform analysis complete", output
    assert_match "Hello from tfmcp!", (testpath/"main.tf").read
  end
end
