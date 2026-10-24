class Panix < Formula
  desc "Deploy Nix configurations across machines"
  homepage "https://github.com/mihakrumpestar/panix"
  url "https://github.com/mihakrumpestar/panix/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "9735070d8a5bea92067df8ed20ab727ad8033b31210b7559a6c13139fedbb7c3"
  license "AGPL-3.0-only"
  head "https://github.com/mihakrumpestar/panix.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e774cfe3bda14809c68f030aa06838cf1d4907de8a70f5c79f49e4864dd9eaa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e774cfe3bda14809c68f030aa06838cf1d4907de8a70f5c79f49e4864dd9eaa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "276b4ec815168e67bc6861d2d8160af804b7a5a341b59158d0a25f24b5bc169d"
    sha256 cellar: :any,                 x86_64_linux:  "a779953997ee7fc1d409f67869e286dad59950c8fc159f8251ea8c9805cc77f3"
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
