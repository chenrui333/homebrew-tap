class Paq < Formula
  desc "Fast Hashing of File or Directory"
  homepage "https://github.com/gregl83/paq"
  url "https://github.com/gregl83/paq/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "cf94768ec273f08fd84348409c37d1bc6192d3e35d4090aeedd0b3c0281b65fc"
  license "MIT"
  head "https://github.com/gregl83/paq.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45ce0a4609970a5b74a868efe07ac239a6e3feaa8858ae373fb077ab4dbd839b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "405aa66d0a2a4dd108a5da2403b2080f332d240c2018433fda5b398fd0b2551b"
    sha256 cellar: :any,                 arm64_linux:   "da1f79f9207ca57f88d0da67a3136e130469f3eef94e1681447c5c112d8ad38d"
    sha256 cellar: :any,                 x86_64_linux:  "d4acc36446bf8927a5dcdd826f22a0ce67c3616fbcb016025f5ccb7a551d9b1c"
  end

  depends_on "rust" => :build

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
