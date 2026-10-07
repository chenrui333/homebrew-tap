class ViMongo < Formula
  desc "MongoDB TUI designed to simplify data visualization and quick manipulation"
  homepage "https://github.com/kopecmaciej/vi-mongo"
  url "https://github.com/kopecmaciej/vi-mongo/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "924c585451d5f9ec590d46fa5ba706e9e3ea3b2732ecec0b25a46dfc4939c8c0"
  license "Apache-2.0"
  head "https://github.com/kopecmaciej/vi-mongo.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1e2024c375ecfeebfa6f3411ef33fec9a32547bb39000bd08ad5756c78853cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1e2024c375ecfeebfa6f3411ef33fec9a32547bb39000bd08ad5756c78853cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2101385ed195fced783ee73065c78d257642bbd6fdb9dfc1e5cf636177c16c30"
    sha256 cellar: :any,                 x86_64_linux:  "81294faaa0032887dc8a127b7aec508139b5b3597c85d27f5cb18a91e42331e6"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X github.com/kopecmaciej/vi-mongo/internal/build.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin/"vi-mongo"} --version")

    output = shell_output("#{bin/"vi-mongo"} --connection-list")
    assert_match "connection", output.downcase
  end
end
