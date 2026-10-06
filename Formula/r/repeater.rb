class Repeater < Formula
  desc "Spaced repetition for the terminal"
  homepage "https://github.com/shaankhosla/repeater"
  url "https://github.com/shaankhosla/repeater/archive/refs/tags/v0.1.7.tar.gz"
  sha256 "fd66bcb2c74c596b133b80b5a136adb6c1ffd241543766cfdbf404f75e110c23"
  license "Apache-2.0"
  head "https://github.com/shaankhosla/repeater.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "35a318b7509af645f280a44546a77056eeb3e4fbbeef59890921bcca04713e15"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27b1a07ed329409843443e649af3559c3b01f5c3c5dc4b4c4a53000bb34f5bad"
    sha256 cellar: :any,                 arm64_linux:   "527ebed951d04f729c3e2eb3a55eca72a4657fefd16bfb437fbd99e5d53fb0ca"
    sha256 cellar: :any,                 x86_64_linux:  "ec3549756ffde995fa19abbd0b2f3ea5e0887867aa2e5e266f9ce2f45a104dfd"
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
    (testpath/"cards.md").write <<~MARKDOWN
      Q: What does a synaptic vesicle store?
      A: Neurotransmitters awaiting release.

      ---

      C: Speech is [produced] in [Broca's] area.
    MARKDOWN

    assert_match version.to_s, shell_output("#{bin}/repeater --version")

    output = shell_output("#{bin}/repeater check --plain #{testpath/"cards.md"}")
    assert_match "Collection Summary", output
    assert_match "Cards found:", output
    assert_match "2 cards", output

    data_dir = if OS.mac?
      testpath/"Library/Application Support/repeater"
    else
      testpath/".local/share/repeater"
    end
    assert_path_exists data_dir/"cards.db"
  end
end
