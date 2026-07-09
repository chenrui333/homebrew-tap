class Gitpane < Formula
  desc "Multi repo Git workspace dashboard for the terminal"
  homepage "https://github.com/affromero/gitpane"
  url "https://github.com/affromero/gitpane/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "5999d1cf93334938b6ff961ac04ae8f8a5fc42ece31b77da48c4067fca23ac6f"
  license "MIT"
  head "https://github.com/affromero/gitpane.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e8e44dacc3542b4f86208de4a6bb7831e31260995143c0f562d55f60e6158dfa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4bfbd7a4875a564b1c7e0a7f061c6a97898193b62d4deaad7c5ebe1574cf5924"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0313e4ac2e28b6935887f2ae1df46b711e050e263157fad2b483ae73dd95231"
    sha256 cellar: :any,                 arm64_linux:   "ddd6813411ee778ba5b51fed64e2260d82ddb675f4788cf2d2379318f03355e6"
    sha256 cellar: :any,                 x86_64_linux:  "17042cfa8d25f9f1eebc79c620e36ae2b4890246ec99b77abcd2bb754c63e11c"
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
