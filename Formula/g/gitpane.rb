class Gitpane < Formula
  desc "Multi repo Git workspace dashboard for the terminal"
  homepage "https://github.com/affromero/gitpane"
  url "https://github.com/affromero/gitpane/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "e23ba1fae2b8ced2019299c86b994895caa64e966f7f3dab543d25dc417cad70"
  license "MIT"
  head "https://github.com/affromero/gitpane.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3aa6cf6f3bf5787f59367f933ef782e2789d21ac4ec624df28274ee0586f406"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6104637db6f9c3f0cc0e65d5598347a345b65870724c86114e960b77bbc50fab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39b67c35a9109f4be308c752b8110d6e28e88ac356682a0818fae28566a583d7"
    sha256 cellar: :any,                 arm64_linux:   "0d81fed4849194934baac63af758eb7a0d4da3a459e077c34553d1c8a5a859de"
    sha256 cellar: :any,                 x86_64_linux:  "f046a8cacf0e2cf65b0ce52f3e09dd7f043c3b4d9f375c827ea18c32ba6afb03"
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
