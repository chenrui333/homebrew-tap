class Dcv < Formula
  desc "TUI viewer for docker-compose"
  homepage "https://github.com/tokuhirom/dcv"
  url "https://github.com/tokuhirom/dcv/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "c09ca4a2ddc9378316b6ed336203d38a64f329e562665319106f2c9b83f6c18d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd22a144b10dd1b377e9c36aba98d6af3e1dc620b350c08a2b4d965b1eb42090"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd22a144b10dd1b377e9c36aba98d6af3e1dc620b350c08a2b4d965b1eb42090"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd22a144b10dd1b377e9c36aba98d6af3e1dc620b350c08a2b4d965b1eb42090"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf342ed3efdf7c67c808700a6691e462372c0509b50ff9bd7632416f8aef15d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c91223dddde3229f5b7459594e3cde86abb36efd004c0ef3ea7f8c49ca4054e"
  end

  depends_on "go" => :build

  def install
    system "make", "build-helpers"

    ldflags = "-s -w"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    # no version command to check
    system bin/"dcv", "--help"
  end
end
