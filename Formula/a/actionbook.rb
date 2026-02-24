class Actionbook < Formula
  desc "Browser action engine for AI agents"
  homepage "https://actionbook.dev"
  url "https://github.com/actionbook/actionbook/archive/refs/tags/actionbook-cli-v0.7.5.tar.gz"
  sha256 "dd5c9bbf9794226b9a18ed963838312c01d4c7e2cdeb7cd1421aa0f443fcb171"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "86c9e710d2de23495d7bd44aa005c8315a45d0a7a29d3ec014196e7a82ee77bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "457156a7386bb944293164c300eb10a892ce8fc4005787ed41cd56d7b1ab5620"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be12ab8c2d84cbabc6ea839fca5bf12979092515afe13c9e11dbf60e26cf7ede"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0b36b4e7927a8e475e1b82049b21207900015da7ddb95ef6dfca409266370ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7dfc1b2917a8f45a138a0b74a2ae0991b0962d51a277e510019361eee3815d3d"
  end

  depends_on "rust" => :build

  def install
    cd "packages/actionbook-rs" do
      # Keep binary `--version` aligned with the tagged CLI release.
      inreplace "Cargo.toml", 'version = "0.7.1"', "version = \"#{version}\""
      system "cargo", "install", "--bin", "actionbook", *std_cargo_args
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/actionbook --version")

    output = shell_output("HOME=#{testpath} #{bin}/actionbook profile list --json")
    assert_match "\"name\": \"actionbook\"", output
  end
end
