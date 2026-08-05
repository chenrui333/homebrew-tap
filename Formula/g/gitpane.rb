class Gitpane < Formula
  desc "Multi repo Git workspace dashboard for the terminal"
  homepage "https://github.com/affromero/gitpane"
  url "https://github.com/affromero/gitpane/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "64907b482f889d667e0036761265500334864c6c85185b9f2d2af6538a94eda5"
  license "MIT"
  head "https://github.com/affromero/gitpane.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a95bfe951efcaa0feac4d16b235106fbe1a32c2900188aedebf247d822452e76"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb56745f67be3d994bf0ae9b5fa1970066fca016c2b056fcf19a3ae0899db3dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "997555ac20d7a8b7838b917fa78646ada8050a706619225b76d43dd345ba2151"
    sha256 cellar: :any,                 arm64_linux:   "b51c16c5559495cfc5b251f79ece952c9f6fafb42e64824d0db66689b29c8f94"
    sha256 cellar: :any,                 x86_64_linux:  "e854a1aac783abd0ca99fb001af094839d901433113eb9b8aec109aa5f197c74"
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
