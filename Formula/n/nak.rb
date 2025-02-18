class Nak < Formula
  desc "CLI for doing all things nostr"
  homepage "https://github.com/fiatjaf/nak"
  url "https://github.com/fiatjaf/nak/archive/refs/tags/v0.11.4.tar.gz"
  sha256 "b2fa16c3582b3fdefc909adf46fd227f840c9430c606581087c6c8a0c877d2f2"
  license "Unlicense"
  head "https://github.com/fiatjaf/nak.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa90ffad1200ac209e39297c64158a512c62649c438e7011ba6fbe29cc67f013"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef9c25a9090b5ddf9aa3590ca185964d1f24ad919e05b5f9ed45c17d00193c02"
    sha256 cellar: :any_skip_relocation, ventura:       "853c2d0ee8174ceea448e1c225c37bbf3bade06cbd49ae3ba5b2d08bbf4fe85e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72eae59da7afe14ccc78037f0a9fb5cbf80531fb3d5f2c73bc815ff708ae3b1a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nak --version")
    assert_match "hello from the nostr army knife", shell_output("#{bin}/nak event")
    assert_match "\"method\":\"listblockedips\"", shell_output("#{bin}/nak relay listblockedips")
  end
end
