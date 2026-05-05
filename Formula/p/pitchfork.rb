class Pitchfork < Formula
  desc "Daemons with DX"
  homepage "https://github.com/endevco/pitchfork"
  url "https://github.com/endevco/pitchfork/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "68c6373a824ec7fe694f63e2902b2ad75eac320bebe066f9510ab33f660b08f4"
  license "MIT"
  head "https://github.com/endevco/pitchfork.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "245a63d147db27ba00f27620dd4ae02be33622c1182c3f17cd7153609b8be007"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0e73ca5ee33352d3331bd921811fbcb4cfa841751d2cadf7ca73fe7c3535868"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7c613ca695a9c698ea0434548d614d33c30c68b1db73d019974d2443dfe008c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa2eff896a5d76498a3e2db9c5dcdd61717971667c15ea10c14b5552607d3780"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbd41b57583fcf20aaca6b2d8dd5375c546e33e35b3f2a9051a16bd1544cbc1e"
  end

  depends_on "rust" => :build
  depends_on "usage" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"pitchfork", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pitchfork --version")

    (testpath/"pitchfork.toml").write <<~TOML
      [daemons.test]
      run = "echo hello"
    TOML
    output = shell_output("#{bin}/pitchfork list 2>&1")
    assert_match "test", output
  end
end
