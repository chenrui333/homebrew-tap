class Paq < Formula
  desc "Fast Hashing of File or Directory"
  homepage "https://github.com/gregl83/paq"
  url "https://github.com/gregl83/paq/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "191a4bfa8a0e187138d830cd08aa53dbb4c19ddaafbc1d9c30aa71c99b8c409d"
  license "MIT"
  head "https://github.com/gregl83/paq.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d03d2a246604edbd00962642c12645883073d8030cba15e886f05fa1ac5cc9f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0d6cda371cb503b76dabd72efa98de33a60995f7ef9ad5084b8bbba931563d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da7fc8e655903d95ff0356d121c818f9769659278a44bde5242d487a56899896"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59852d695ab1af32588183a850467a8df173b182395a271e7c650744b9dbeb9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9dd08edef28ec9ff71b2b1ea60ac36accb99c5ef427652bb43de5cb72b4faac2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/paq --version")

    (testpath/"test/test.txt").write("Hello, Homebrew!")
    output = shell_output("#{bin}/paq ./test")
    assert_match "eb9122ffff587d1cb9e56682d68a637e8efaa6c0cd3db5d90da542d1ce0bd2c2", output
  end
end
