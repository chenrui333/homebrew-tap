class Wisu < Formula
  desc "Blazingly fast, minimalist directory tree viewer"
  homepage "https://github.com/sh1zen/wisu"
  url "https://github.com/sh1zen/wisu/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "0331ebc1663c3fcc4c58992692b6dc952d8733d1d77efac71250bb2689925edd"
  license "Apache-2.0"
  head "https://github.com/sh1zen/wisu.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d65258df97005a56c6446f2450cf168c18619db3cbe8b29fbf91648a01c43db9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f0d64466ee9f9cad079b7578d2889e94330cc70ab08e3dfe79cd91535b0160f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a18c8a124f0f856c48d27267707abe9795fad2708fc42cffa764ece8f617e93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc7b16415fb4227624fb86e8fd3150aa7556238bc31903f366ae53c6aebcba92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be2ea0ce9d474178e09effde91c8106e8ec9053acd59211ceb13f233180454cb"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wisu --version")

    (testpath/"dir1").mkpath
    (testpath/"a.txt").write("a\n")
    (testpath/"dir1/b.txt").write("b\n")

    output = shell_output("#{bin}/wisu #{testpath}")
    assert_match "a.txt", output
    assert_match "dir1", output
    assert_match "b.txt", output
  end
end
