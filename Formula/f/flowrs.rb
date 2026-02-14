class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://github.com/jvanbuel/flowrs/archive/refs/tags/v0.8.10.tar.gz"
  sha256 "28c5acbc903e8690da3d73cdc0881b65071f23abe30299cfeefd7de6df73253c"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7457fe2c271ebb151c4a93d2105b13d50e615f42784cceb04b423905de5e2133"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb09c65fbc67d59c8ed6cabeaf1a3052abf5694cf59d15b17d493637ad8326e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f88de11ae651bbdd23c8f455f325ec809e1174f49d0554805b553fc9b759cd2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db12933dee42ae5c5bc53a75a75d16fdd1c2743890557ad0b7b13666ed0efcbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c754eee373e0da0866ba46c8e199da76b233d4fc25d56219939a1fa5f25a1fd"
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
