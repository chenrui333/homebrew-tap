class Tfmcp < Formula
  desc "Terraform Model Context Protocol (MCP) Tool"
  homepage "https://github.com/nwiizo/tfmcp"
  url "https://github.com/nwiizo/tfmcp/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "d4c0f16992f89f6c45d66c34eea578ca8e91c08f1027941f326de345487e29ba"
  license "MIT"
  head "https://github.com/nwiizo/tfmcp.git", branch: "main"

  depends_on "rust" => :build
  depends_on "opentofu" => :test

  # opentofu support, PR: https://github.com/nwiizo/tfmcp/pull/3
  patch do
    url "https://github.com/nwiizo/tfmcp/commit/9e27ef3a70337da8eae56644ea8c2db833a4fba5.patch?full_index=1"
    sha256 "89b08ff3f08a8a5733b4b1c39b119eee1ed1c20aaf35319ae60570e7b73066b6"
  end

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
