class Panix < Formula
  desc "Deploy Nix configurations across machines"
  homepage "https://github.com/mihakrumpestar/panix"
  url "https://github.com/mihakrumpestar/panix/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "f86a241ae66234f78eac77516957885874a87a33f7a8be430051959e74914ddc"
  license "AGPL-3.0-only"
  head "https://github.com/mihakrumpestar/panix.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc34787649cc2f9381e989c290d4f93180af86cb2111537689fe950ad01d3675"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc34787649cc2f9381e989c290d4f93180af86cb2111537689fe950ad01d3675"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e213d755f94ba864d85e6f4b74649fb6c877b910a9663cf44d58f0a14bcfb0b6"
    sha256 cellar: :any,                 x86_64_linux:  "26ca1e04bb4fad07804f44621e9181116cb1cf78f2a4fd9821673e284ecd4f7a"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/panix"
    generate_completions_from_executable(bin/"panix", "completion", "--code")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/panix --version")
    output = shell_output("#{bin}/panix schema --output -")
    assert_match "Panix Configuration Schema", output
  end
end
