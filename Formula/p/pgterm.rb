class Pgterm < Formula
  desc "Terminal-based interface for PostgreSQL"
  homepage "https://github.com/nabsk911/pgterm"
  url "https://github.com/nabsk911/pgterm/archive/566f9525e821b4f05ef7c31bb4dc293e28a90f9b.tar.gz"
  version "0.0.0"
  sha256 "0d6f6b8c0171c7b4e0bbb39b20e41cefa62bec7407577c16433d18c3c7f4ed77"
  license :cannot_represent
  head "https://github.com/nabsk911/pgterm.git", branch: "main"

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
