class Gitpane < Formula
  desc "Multi repo Git workspace dashboard for the terminal"
  homepage "https://github.com/affromero/gitpane"
  url "https://github.com/affromero/gitpane/archive/refs/tags/v0.18.4.tar.gz"
  sha256 "97971fd5a24b42927fa35ac17b4c4f471afa2ed7d32a7d9e5b035011519ded3f"
  license "MIT"
  head "https://github.com/affromero/gitpane.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "08426a506cdbe96ff8ee11d3c1366376c077c96c1397f7034c344bec010698eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ed563062edfa72ffb5807d5d7301ecda4bd95fdc35bab351a39f6a3a96adc81"
    sha256 cellar: :any,                 arm64_linux:   "7fccf01282c5af0483f5331d5681432287be6f43001d95533195f0504f2cb687"
    sha256 cellar: :any,                 x86_64_linux:  "183d9e7bd8c57d0d618a2d78488d70c6eaa8dbce21d0d02e289e9511e808b0e8"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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
