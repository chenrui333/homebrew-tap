class Paq < Formula
  desc "Fast Hashing of File or Directory"
  homepage "https://github.com/gregl83/paq"
  url "https://github.com/gregl83/paq/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "7015036560793f644fb37315da92eccf49768480703ecb47f8abc455644b1209"
  license "MIT"
  head "https://github.com/gregl83/paq.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b1b2898ed560c4e00aeea0db8992325511acb8935a12c7eb823fb2158f07bb2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eae15b2a8da3811c3df5bb6a47d7fcc36ed7fea4123488c386082925c87034fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c97bf8e38c62b50a968d8c63aefe378781c21d3c85b13afe89afc1df4205326d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c67a87621a98a0a51b29bcc9317acf5c95f81ec115bb4c81d9becdefac35a026"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9925b68f7459e33afa46f56a6dc893153eb697fc2c2d67105a6ff7d5bfbe1fb4"
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
