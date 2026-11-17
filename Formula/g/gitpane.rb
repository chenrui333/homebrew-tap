class Gitpane < Formula
  desc "Multi repo Git workspace dashboard for the terminal"
  homepage "https://github.com/affromero/gitpane"
  url "https://github.com/affromero/gitpane/archive/refs/tags/v0.18.12.tar.gz"
  sha256 "fe235a4d45b219488e75542ef7a6ed48a6b3834568fdf7386c6eae986bb13df5"
  license "MIT"
  head "https://github.com/affromero/gitpane.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da2d7721c04858cb30f2f966522a05ed51cb55bd852c3b7434767df31b163557"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fc03e6f877a3697b6d557d619a39477acb28be48ed7b48dfe1abb10fa6fbce4"
    sha256 cellar: :any,                 arm64_linux:   "f8175be202b06e9df6a4102d5979a154cdfb5e6c7509168ca2c097e4c921ce39"
    sha256 cellar: :any,                 x86_64_linux:  "5561f9b91c882fe77e1c39db031f332e41f2df418477012581529a99c76c323f"
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
