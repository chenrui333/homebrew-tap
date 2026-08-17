class Gitpane < Formula
  desc "Multi repo Git workspace dashboard for the terminal"
  homepage "https://github.com/affromero/gitpane"
  url "https://github.com/affromero/gitpane/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "7aa88a3dd643d1da5104bdd53f0794de06bec74f9a09ee67a6c9bd3ab320d0b8"
  license "MIT"
  head "https://github.com/affromero/gitpane.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "110a0cf6d524b89d76785580db9a1ddef49d146256a515ae929a35d9e3eabc11"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b75b682e97e65934f7f742d93ca432dc09144dc0f78d368cb4619ef835406b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b8034f0ad67c2f908fceb91cb7cf7811dca7565a9e42fe8a0fca6c94c8eee07"
    sha256 cellar: :any,                 arm64_linux:   "4a91d3508d16c5496d6df52c1c651321e4878f91cf53a5d49f619bddc3f2d564"
    sha256 cellar: :any,                 x86_64_linux:  "2412f8134fa413a58d1d2d1269e67444d48d98a23f6cfc58a46d7e0e8544947e"
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
