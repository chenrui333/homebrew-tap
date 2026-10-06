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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b265235ee8290ccd9d498310d74af41a37408de6786dc5c87aaf16219623177"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b265235ee8290ccd9d498310d74af41a37408de6786dc5c87aaf16219623177"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a73ac7156985ac479ccc26f8477027a323c3f2faf3d75c5f26b9579654737473"
    sha256 cellar: :any,                 x86_64_linux:  "121499c18b2c06f7769dbfc5873d7799c17ca7d6ad10c1fea6794895c0fe062a"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/pgterm 2>&1")
    assert_match "Error running the app:", output
    assert_match(%r{(/dev/tty|terminal not cursor addressable)}, output)
  end
end
