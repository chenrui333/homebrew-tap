class Panix < Formula
  desc "Deploy Nix configurations across machines"
  homepage "https://github.com/mihakrumpestar/panix"
  url "https://github.com/mihakrumpestar/panix/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "f86a241ae66234f78eac77516957885874a87a33f7a8be430051959e74914ddc"
  license "AGPL-3.0-only"
  head "https://github.com/mihakrumpestar/panix.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b7bd30fc0a8eb004a66911c144ae5e8e0ccd0fbbdab4c6f9782198128db89db0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7bd30fc0a8eb004a66911c144ae5e8e0ccd0fbbdab4c6f9782198128db89db0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7684da1ac439f5e5b2113e952be0772b4d653c467fe807d7991f8f318c2f8cd5"
    sha256 cellar: :any,                 x86_64_linux:  "6faf46576843b506d71c89f7708e0087152ea35dbc8e7495f75eb2a494fe5371"
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
