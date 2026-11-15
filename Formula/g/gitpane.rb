class Gitpane < Formula
  desc "Multi repo Git workspace dashboard for the terminal"
  homepage "https://github.com/affromero/gitpane"
  url "https://github.com/affromero/gitpane/archive/refs/tags/v0.18.10.tar.gz"
  sha256 "afb9b1bd09918aac779cd5b65749315ea299c714a3014701e93af00624844d3e"
  license "MIT"
  head "https://github.com/affromero/gitpane.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e96947a5375757240f2cb2e9f77b8b9bc1432ae6013940d4f38a435277d73044"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22a2b8169db3fe39a718bf4261de1365c13e958cd4aca2f516eefa1886aa5f4b"
    sha256 cellar: :any,                 arm64_linux:   "36cf55a0dd23a727e5a2070f9c7df40cc5dfb81da02044a87d17b103122f0466"
    sha256 cellar: :any,                 x86_64_linux:  "f268a54cc7584014e509d7bcd8128d2c419a7345c0543a85b3923fa0c2f1e84a"
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
