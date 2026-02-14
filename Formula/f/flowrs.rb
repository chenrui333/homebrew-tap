class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://github.com/jvanbuel/flowrs/archive/refs/tags/v0.8.10.tar.gz"
  sha256 "28c5acbc903e8690da3d73cdc0881b65071f23abe30299cfeefd7de6df73253c"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b26bc40d64c01986e4a69a6492c6aa3c292c64cf1f280a9d2f6e5d100160de6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f77c139e241cb7c31a622287a8ec5734f0ff9892f2baf59120133076ea810255"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54c9d218641ee28864cba9608f0752eeecba83141c64deea4a9cfe0a33dcb125"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61ba8a0090b258770ebe378edfca342fd495a5bfab869e3d35418afa92ca978d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2e6c96bd639ae18e301860d58e2a37e7530c796e5054f6d65186fe7bd7fd0f7"
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
