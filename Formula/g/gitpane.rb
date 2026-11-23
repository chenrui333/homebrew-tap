class Gitpane < Formula
  desc "Multi repo Git workspace dashboard for the terminal"
  homepage "https://github.com/affromero/gitpane"
  url "https://github.com/affromero/gitpane/archive/refs/tags/v0.19.3.tar.gz"
  sha256 "aef1199677f2c95368bda1fba1d59f66f481fab9d2b0d648f00dea315052a52e"
  license "MIT"
  head "https://github.com/affromero/gitpane.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "3e7c157fdd86258cfbdb287483025b0dc4768dc3ad25cd517e0597d83a87ba4c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e30a209c8676af4d5ea8face12c2e9a25aebdbfb1c7867139050edf21c01b38b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "523076442dad03cc5aff5ecc18dfe0b039a8c973d5bdefee2da245dcf9cfd85b"
    sha256 cellar: :any,                 arm64_linux:   "5daddd8b550d77b7e8a2bfd16b6a747dcd1979ce811ec2e89a500e38895ea163"
    sha256 cellar: :any,                 x86_64_linux:  "2bd970679199b5deb33f2501ce6e44ce461aca53d84ec9ec1295ed137f684641"
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
