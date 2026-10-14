class Datui < Formula
  desc "Data exploration in the terminal"
  homepage "https://derekwisong.github.io/datui/"
  url "https://github.com/derekwisong/datui/archive/refs/tags/v0.4.8.tar.gz"
  sha256 "adb431cb2ab172fbd3284c91f55031788bd7b1d70017cb274b487b32d16bb384"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dec2a4556e136a3713519942b0d02ee31c41eaba58d0d66a76617b89ba2a3435"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a072fce0f9ee38bee480dface9dcedc2bf5b065ff41fb4b6eead18d832bb923"
    sha256 cellar: :any,                 arm64_linux:   "6b3e13dfca0bd5da3bf080b36558daeb1eca04de7c2ecb17416896d7cb74bb60"
    sha256 cellar: :any,                 x86_64_linux:  "29e6a89b59d6c166e5407091c1c74390766da9c0f2379e0fc1b5dfb81a7cb9ed"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "fontconfig"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", "--bin", "datui", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/datui --version")

    output = shell_output("HOME=#{testpath} #{bin}/datui config init")
    assert_match(/Wrote .*config\.toml/, output)
  end
end
