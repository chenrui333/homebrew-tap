class Gitpane < Formula
  desc "Multi repo Git workspace dashboard for the terminal"
  homepage "https://github.com/affromero/gitpane"
  url "https://github.com/affromero/gitpane/archive/refs/tags/v0.10.3.tar.gz"
  sha256 "ffbd6eadcca9f7393bdc3f20f15b9abb5977a27e4d2079f6da60d5c50c5072bd"
  license "MIT"
  head "https://github.com/affromero/gitpane.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ba5baa99f0bda6e520aa300cf199b01e4d1c7d821ecfba56c1f68dce9448b6f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1fa1418dc27138dc62f0c795340628c58eea9fd237bd8c1dea223cdd6950016"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "414e379b21bc7b2eb016e8195f55086d964eb223237de15f568d33076c613ca1"
    sha256 cellar: :any,                 arm64_linux:   "5dbea0c13c79593ea7301b50cf944cec6436f448e051cdfc6518ec8acd038e1b"
    sha256 cellar: :any,                 x86_64_linux:  "2e4966a2df82784dc785cda2c6bfa1a5bd9206b393d0f4c7531a2b59e8fa2c9a"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "open3"

    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    output, status = Open3.capture2e(bin/"gitpane", "--not-a-real-option")
    refute_predicate status, :success?
    assert_match "not-a-real-option", output
  end
end
