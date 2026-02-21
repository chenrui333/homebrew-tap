class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://github.com/jvanbuel/flowrs/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "ec7a1bc580d3e647e054b59e6c2b8356114fdc30c7d407813f98432735940f52"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0d27bfc9894e85f671d2869901ed44f811b5a50d0a1914584850d755ba9a417"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c81d082a95b2193217cb65668789d97d5a8c6954107ac64a6c343ffcea51242"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56062e6a9aaadb95baf290961d75ef15ea323e16e2dfe6f414f0fe0578859cd2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fbaf6ebe5e2a5289c0ae267fe3b1540630f2ad4c76cbe93ca0b031dee464e9f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4571cf4d8c3bb24ed4cb576abc823fc2a4ca6a04cab227b19758b5c36ec710e6"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flowrs --version")
    assert_match "No servers found in the config file", shell_output("#{bin}/flowrs config list")
  end
end
