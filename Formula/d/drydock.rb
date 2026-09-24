class Drydock < Formula
  desc "Dashboard for a fleet of Git repositories"
  homepage "https://github.com/yetidevworks/drydock"
  url "https://github.com/yetidevworks/drydock/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "88183f8bc021537e256b63a05da5a9496d33d7087d5f8c71405a48857e505510"
  license "MIT"
  head "https://github.com/yetidevworks/drydock.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0c0e53d0bbb75bb81fdb68504928b0f8b27144df9e7c58872e4a64704c31c8d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3bd8954742575254de0eb9ff901e5831b30ffb2ad8450f8814e8eb8ea231d44"
    sha256 cellar: :any,                 arm64_linux:   "2907c24780aa2917392ea39c183fd5ff95659d2195498f2b6214a8a58fb98af6"
    sha256 cellar: :any,                 x86_64_linux:  "65e99c6b1577a7374149a176fad7e17d94c6103820430e3ce3ffdd0b47c0a31f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/drydock")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/drydock --version")
    output = shell_output("#{bin}/drydock config show")
    assert_match 'roots = ["~/Projects"]', output
  end
end
