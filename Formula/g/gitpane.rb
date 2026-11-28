class Gitpane < Formula
  desc "Multi repo Git workspace dashboard for the terminal"
  homepage "https://github.com/affromero/gitpane"
  url "https://github.com/affromero/gitpane/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "4ae8dca3239586ed0361e91a709c70ed12da373cb1c3045343e8638c670ba589"
  license "MIT"
  head "https://github.com/affromero/gitpane.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "d313c353366de33ac01172f98a6671b68b35a6c0a0f6b172f6cedef337e6de51"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe908e23327cff794827297aa1630963c1998f7c5cf96ae70b0f053317832f91"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "123aebcf705c781807b3a781d3f1a03c9c5563aed074861901cd16162b4c7b36"
    sha256 cellar: :any,                 arm64_linux:   "196cccba6cd527b5a30df7f415e7ba157bc378bea509c1d374ae109da3430cd3"
    sha256 cellar: :any,                 x86_64_linux:  "a027ff79fdec0e58ae8391a6066737c637257cd0a19c99800943d5ab963ef087"
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
