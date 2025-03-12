class Tfmcp < Formula
  desc "Terraform Model Context Protocol (MCP) Tool"
  homepage "https://github.com/nwiizo/tfmcp"
  url "https://github.com/nwiizo/tfmcp/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "d4c0f16992f89f6c45d66c34eea578ca8e91c08f1027941f326de345487e29ba"
  license "MIT"
  head "https://github.com/nwiizo/tfmcp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2363405c0c210f338aa9cb344a04e27fa6f975d7f2c7054d7f197f9b27f26519"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1982d572106349c4b48a9c141bc71f19babe413483fdde4a344f86dd73e0a559"
    sha256 cellar: :any_skip_relocation, ventura:       "eb5d41ece35a67f4e96d9ee12cbe3be1727514e338fff066f8dd84e1c1a599b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb215a4f44c759f228fe827f57a06bc89e438c5e6f49fe7b792615fc05af2a9c"
  end

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
