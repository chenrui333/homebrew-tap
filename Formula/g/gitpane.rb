class Gitpane < Formula
  desc "Multi repo Git workspace dashboard for the terminal"
  homepage "https://github.com/affromero/gitpane"
  url "https://github.com/affromero/gitpane/archive/refs/tags/v0.20.2.tar.gz"
  sha256 "1beb25444d4bcbe82b7bf07c4341d8d62f0fd99f0ea69deb5d848d4ee650573f"
  license "MIT"
  head "https://github.com/affromero/gitpane.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "79e7331374b1ecc7d03f8255b666e14c07aee3d9504c409967fc2a4e70e81214"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "96b6a965e6c2ba2460fab4eb3b54874b574990f3c92b70e76e990d9f80219e47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f41054c6a004be6057681b0b642154c561296a92eaa7f76f204b0fd21cc03cd"
    sha256 cellar: :any,                 arm64_linux:   "5d462b046cb94f336896c66009cad70191cdc7c909c34899709f48ad0f860038"
    sha256 cellar: :any,                 x86_64_linux:  "72c9c7322cf3a2d5ffc726860556a7e75cf153979d96ff2a8d7a41a2eb3c9249"
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
