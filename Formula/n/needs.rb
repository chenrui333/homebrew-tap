class Needs < Formula
  desc "Checks if bin(s) are installed, oh and the version too"
  homepage "https://github.com/NQMVD/needs"
  # v0.8.0 was re-tagged upstream (no Rust source or Cargo.lock changes); pin the tag commit
  url "https://github.com/NQMVD/needs.git",
      tag:      "v0.8.0",
      revision: "46b12c10c12156cead7a45aef2887a047a7877d4"
  license "GPL-3.0-or-later"
  head "https://github.com/NQMVD/needs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "feb8f6d85a6ba8f47f83fe20938c56f5713eb4bd5fc7750b423ef3b66f9a9846"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6aa638e29823a048bbb161306a6b70d8704459446d3a89891569ff0199115d73"
    sha256 cellar: :any,                 arm64_linux:   "e7a9fa3f8a8cc34095a8b18f9ee4777cecfe686030fad06091a479f8fee91033"
    sha256 cellar: :any,                 x86_64_linux:  "7927a16f3b0d52ffa888285783d02f7504375ab6c9ff021b2916e39ed3b8cce9"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/needs --version")

    assert_match "curl", shell_output("#{bin}/needs curl")
    assert_match "go not found", shell_output("#{bin}/needs go")
  end
end
