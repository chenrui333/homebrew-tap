class Gitpane < Formula
  desc "Multi repo Git workspace dashboard for the terminal"
  homepage "https://github.com/affromero/gitpane"
  url "https://github.com/affromero/gitpane/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "6d4b9c8a3ed29e5c1e62182ffd09a4c143b6b651f7bdd5a888269d2d605f301c"
  license "MIT"
  head "https://github.com/affromero/gitpane.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "713e769946fc42a84241900f6ce2315dff6b57a537b9a187eda17510331af754"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba5f0ca065bc98ac98bc4513660eaa91e8b4f90296da2c28a9a65eb5fd780ed9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a6f26a85b8033d26f8080db0b39c748addbb5f707a0ee1082f80a2f0974f0f8"
    sha256 cellar: :any,                 arm64_linux:   "8697732c6c5c0fe930a8a7717e61e8eba8859d61269526ec4bb39b6a45f1fc93"
    sha256 cellar: :any,                 x86_64_linux:  "154ff33a8db78e0d826a5f765acc725ed70c2a6657e1af1f2d89270ce8e22dbb"
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
