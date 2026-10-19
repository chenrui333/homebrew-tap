class Elio < Formula
  desc "Terminal file manager with rich previews and inline images"
  homepage "https://elio-fm.github.io/docs/"
  url "https://github.com/elio-fm/elio/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "7a78b104e48f94a0460333a02f5e5f3a95dad11ec21a24e2b0be69d6e1974799"
  license "MIT"
  head "https://github.com/elio-fm/elio.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2857241030be364ed9da740916a3570e62e92daab65555927f90d0f70db19fc1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be9915e437b58b0e0361e867853af8900b77769a36eb4efb1ec6c8c4f75f4496"
    sha256 cellar: :any,                 arm64_linux:   "a30b493ead72bd57364dbcdb2467ade21c93912e31a542aa117828b0c4c2374b"
    sha256 cellar: :any,                 x86_64_linux:  "0fbb25cbd5f2d20dbb17f39b48d889c68885ffea251fb106a2cf1be200ac11c3"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked"
  end

  def install
    ENV["CARGO_NET_OFFLINE"] = "true"
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/elio --version")
    assert_match "elio() {", shell_output("#{bin}/elio shell init zsh")
  end
end
