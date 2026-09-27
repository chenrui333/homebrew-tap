class Gitpane < Formula
  desc "Multi repo Git workspace dashboard for the terminal"
  homepage "https://github.com/affromero/gitpane"
  url "https://github.com/affromero/gitpane/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "76179a9e312beb5e17842b6ab52ebe4d81a3ae0864d55fcbb090b01a101804a3"
  license "MIT"
  head "https://github.com/affromero/gitpane.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e46c14a8b012d0cb0f7102f9780b6e3499998f7a4a2297cde9dc5e571f3b946"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4538a4d7b809f8de158441e31c26b0d334b902f8cca5b1bb6a428d2e310f01c"
    sha256 cellar: :any,                 arm64_linux:   "dcc4d9e35ad53fe6a2d757856b0eda32eb9ad542ba091eb1b7c9804a04d1879f"
    sha256 cellar: :any,                 x86_64_linux:  "6548946100248b0454bc03e4cc386757833c4b4c004008676175a40d1fa0de04"
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
