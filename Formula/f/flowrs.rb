class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://github.com/jvanbuel/flowrs/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "ad8af35fc65f27fc1454d4705334c8dff112bc402c5362c526ecef7c57da1d88"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71c7aea816078255e1f4d9ca38aa5168f8a2091c9ee2c83f5e268c42706ca5dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c8bc85f87cca0bdfe5df5500f30c6caa7364c89b53484e75581cfb93e0bffcd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13f8c0d3415c7dfd82c14c38575c5e39311b26330294900f74e78d83781ebf84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "658c920faf0a60d529458c44a0aaaaba5d9d1868cf15618632a4ab702f8b9af8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e3e9733c0e6ac7dcce6108a849b3882c5d1ecf37e91ab4b8078b46d3e206d72"
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
