class Gitpane < Formula
  desc "Multi repo Git workspace dashboard for the terminal"
  homepage "https://github.com/affromero/gitpane"
  url "https://github.com/affromero/gitpane/archive/refs/tags/v0.7.15.tar.gz"
  sha256 "2a536b3ecc872a3dfcc8a137abf7b0f9d905adf74f2a374dbcf6831d43699087"
  license "MIT"
  head "https://github.com/affromero/gitpane.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b13e77c5fde4b72c45162bc0da2419fbb1181e13f375de16693451a6479d2ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05ded418fbb510e041f3e97a5b41f35ff79cc29ed63017ddbd34fad6dc15e162"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7dc0d56cde34e35583654203821023bac1363edcb638c0e060e34cd3bfd7f4d9"
    sha256 cellar: :any,                 arm64_linux:   "609784699291900da355fbd76c1673eb509095100ab9d08e6a46284a3d44a112"
    sha256 cellar: :any,                 x86_64_linux:  "0aaaa02de52e4ff7e859468cc7d4f1875373f53dd246927fb92cb65811a7471a"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
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
