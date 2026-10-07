class Excise < Formula
  desc "Surgical terminal storage navigator"
  homepage "https://github.com/findyourexit/excise"
  url "https://github.com/findyourexit/excise/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "a48ea802d3f42090e9d2298fb9f8c0d438c24babfe033e0795a56a61ed4d24f6"
  license "MIT"
  head "https://github.com/findyourexit/excise.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7b95f78a961b304f214d1adf56862e4506504ad1645b0353f8f041187a5a73c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cec5963b5f60833beb3666941bb27b842f5642416175472aaa2de17038cea4de"
    sha256 cellar: :any,                 arm64_linux:   "379bdaf03672885186441c941ac6bae223916bb64f2d2853c78fc83e602cf906"
    sha256 cellar: :any,                 x86_64_linux:  "c4b1b00977e73ac1ef076434f4ba828210070309a29947d2975ed9faf3a70c56"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/excise --version")

    fixture = testpath/"fixture"
    (fixture/"nested").mkpath
    (fixture/"nested/file.txt").write("fixture data\n")
    report = testpath/"report.json"
    system bin/"excise", "--format", "json", "--output", report, fixture
    assert_path_exists report
    assert_match "file.txt", report.read
  end
end
