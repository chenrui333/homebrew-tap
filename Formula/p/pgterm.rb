class Pgterm < Formula
  desc "Terminal-based interface for PostgreSQL"
  homepage "https://github.com/nabsk911/pgterm"
  url "https://github.com/nabsk911/pgterm/archive/566f9525e821b4f05ef7c31bb4dc293e28a90f9b.tar.gz"
  version "0.0.0"
  sha256 "0d6f6b8c0171c7b4e0bbb39b20e41cefa62bec7407577c16433d18c3c7f4ed77"
  license :cannot_represent
  head "https://github.com/nabsk911/pgterm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6a8f10333e5b833e34b420bb8c18eda195c04e4f8ad8d42e73b299868e81aba8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a8f10333e5b833e34b420bb8c18eda195c04e4f8ad8d42e73b299868e81aba8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a8f10333e5b833e34b420bb8c18eda195c04e4f8ad8d42e73b299868e81aba8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6885461b51213a6f3e9eb448b7de5a4a7ba03825104eab3bcf227ef69b4a689c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58eb3166c73c69ddafef4d4c0ab040bf99b98f2b31551322cbba27c6bcbc7aa1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/pgterm 2>&1")
    assert_match "Error running the app:", output
    assert_match(%r{(/dev/tty|terminal not cursor addressable)}, output)
  end
end
