class Gitpane < Formula
  desc "Multi repo Git workspace dashboard for the terminal"
  homepage "https://github.com/affromero/gitpane"
  url "https://github.com/affromero/gitpane/archive/refs/tags/v0.19.3.tar.gz"
  sha256 "aef1199677f2c95368bda1fba1d59f66f481fab9d2b0d648f00dea315052a52e"
  license "MIT"
  head "https://github.com/affromero/gitpane.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "1c6ffbbe9e89deef858c34a5c5d20f14576fb26d65a1f618852556886f7e1731"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ad89af45658f9f6c3a490b388d7dc82da0c77e11c603269b426286bb5ad2584"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a473a00ff18bd7327be387e3349086a7b286a268cf9d47bfd2ca9e96ebcc180"
    sha256 cellar: :any,                 arm64_linux:   "d4e45a6468c92931603d503fda716a280dfad4996e16c95a02840561bcbc1af4"
    sha256 cellar: :any,                 x86_64_linux:  "f76eb1247e1cfd51743a4e0a6416ab739d15e17681dcadee24ba763db9c53093"
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
