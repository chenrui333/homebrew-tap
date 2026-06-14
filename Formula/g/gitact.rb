class Gitact < Formula
  desc "Explore GitHub profiles, repositories, and activity from the terminal"
  homepage "https://github.com/nathbns/gitact"
  url "https://github.com/nathbns/gitact/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "518b350ce13c29239672e3a2b49d62c8d61bb74578e38198f82c8ea5868e7782"
  license "MIT"
  head "https://github.com/nathbns/gitact.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cddae4607e5e4357ea500187e7c55f29c939dd88a18a3b1d5140791f6a694c4a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cddae4607e5e4357ea500187e7c55f29c939dd88a18a3b1d5140791f6a694c4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cddae4607e5e4357ea500187e7c55f29c939dd88a18a3b1d5140791f6a694c4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e194266497470a26d1eec2a9eee50dae2d624f3fe33bdaad7346cb044cf86a4"
    sha256 cellar: :any,                 x86_64_linux:  "b3300e398dad43d2da06561f44714152ec7f4f3ec311121d0d40b7d980ad5f89"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "."
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.

    output = shell_output("#{bin}/gitact --repos 2>&1", 1)
    assert_match "error: --repos requires a username", output
    assert_match "usage: #{bin}/gitact --repos <username>", output
  end
end
