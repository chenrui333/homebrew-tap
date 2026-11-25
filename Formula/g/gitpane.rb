class Gitpane < Formula
  desc "Multi repo Git workspace dashboard for the terminal"
  homepage "https://github.com/affromero/gitpane"
  url "https://github.com/affromero/gitpane/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "9ef6b537e6d2e5f1311385680d9d502a98bc13072673b8e96bbf04f2355e985f"
  license "MIT"
  head "https://github.com/affromero/gitpane.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "0d089b004e597885c96506011ac6c4e59a2b8099763f9fb61970eac0e74cd447"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "671c2de9d16df41f6293024ac5c97638ec7fcaa9462e9149c4d4687e62c02642"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97c05526b0f69b37289b67c2a339ad7ae5e8cf4747e4e0f65106fb263101a069"
    sha256 cellar: :any,                 arm64_linux:   "675b5c94158690ad8f1bdf3fe2558ee93a836eada9c9f08c55d12f283a5cc75e"
    sha256 cellar: :any,                 x86_64_linux:  "678faf66cef041998757c278ddaea6fc63cd12cd1ce0f86fd31052c07f48535b"
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
