class Gitpane < Formula
  desc "Multi repo Git workspace dashboard for the terminal"
  homepage "https://github.com/affromero/gitpane"
  url "https://github.com/affromero/gitpane/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "7df0d4434fec55352224dea3d6e3349b4c13e84a5a3eee46a3338057ac857454"
  license "MIT"
  head "https://github.com/affromero/gitpane.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf617017958de29cebff721ee73dd8fc254becb0ae1e0deb28c388b2afbd9b06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44967de5266237f70707c39a07e9fbcb8e025c29190d39dd3efcc2176b5f1b44"
    sha256 cellar: :any,                 arm64_linux:   "001389f77e7b697910ba409aa4198874205141e26500c08f1d29cf4e4c7c4ad5"
    sha256 cellar: :any,                 x86_64_linux:  "d278683629d40a6f51e8454c723eac624db7e8f4ff545346cbd18e1910d509b1"
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
