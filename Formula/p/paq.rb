class Paq < Formula
  desc "Fast Hashing of File or Directory"
  homepage "https://github.com/gregl83/paq"
  url "https://github.com/gregl83/paq/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "cf94768ec273f08fd84348409c37d1bc6192d3e35d4090aeedd0b3c0281b65fc"
  license "MIT"
  head "https://github.com/gregl83/paq.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e55906bbe2fe5e0477834f782f2783bd36cb7a0464d59037c3ce54dae5b9a4d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a85055cb91ad38ed93f94086c1d3c9ec09961332be3d71f96b8f05ad20a799d2"
    sha256 cellar: :any,                 arm64_linux:   "1e08e58af7577de5bc74c41d7bdd0625deb42b2eb1a293e1d73ce46665a0f17c"
    sha256 cellar: :any,                 x86_64_linux:  "f23b299225806774cec3e01be564991e326ae2069487666cddcad1387405d5b0"
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
    assert_match version.to_s, shell_output("#{bin}/paq --version")

    (testpath/"test/test.txt").write("Hello, Homebrew!")
    output = shell_output("#{bin}/paq ./test")
    assert_match "ae6457fc0cedc38b3a2dff5dc73751bd759844b4a971659019a514a38d2dd44f", output
  end
end
