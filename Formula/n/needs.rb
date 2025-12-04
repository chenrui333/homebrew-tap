class Needs < Formula
  desc "Checks if bin(s) are installed, oh and the version too"
  homepage "https://github.com/NQMVD/needs"
  url "https://github.com/NQMVD/needs/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "0b20957fd5cfd926ec9e20bb26316322dac73f1788d59d95256cc14f69b13d1c"
  license "GPL-3.0-or-later"
  head "https://github.com/NQMVD/needs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5bc396fb4d6bc83b8f9629a816bc621c0c37f082d7ce885b3a4b7cb3be211423"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83abc163894b0de19b4f97fbe0466c4d92324435d16178c048354c9abf0d949e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ef1ac2396fbe95f5e0eca085d5d35422031dd67bcbfb9dd072943d5cc9b0f52"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45618ec1d637dec7a6c1416ba9a676e382d754e0b5a1c6c74103d2979234f646"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a31f3654e18d94cef6d51d9fd7aaf120bca944f360355e23c29e04cb71ff1790"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/needs --version")

    assert_match "curl", shell_output("#{bin}/needs curl")
    assert_match "go not found", shell_output("#{bin}/needs go")
  end
end
