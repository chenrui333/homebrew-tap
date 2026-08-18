class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.22.tar.gz"
  sha256 "7edc0be11db6bf5aef21d5a1f470f8bfe5e79795f3cef253e40cce7b3fe703bd"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "860be03b61b40dbe4d7295d945bd1d742ee808a7ed72269b7cd9c22281d2d86f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e315e8ccfb594c0450be433cf5c4e6a6e26e3508bb6a4c9015a9f5814fdde9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b88438ae0506a5976ced78de493461f7f51f662d47077fec260f67bbb589de19"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48e4b042838b463b6c626619ca757b690f8c800e858ac9a8c2bd28a35e7147b1"
    sha256 cellar: :any,                 x86_64_linux:  "1910e83029ad4d9217b75746bbc4331a324a374fcf3aa4f3a7742251f79d0450"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/RoninForge/budgetclaw/internal/version.version=#{version}
      -X github.com/RoninForge/budgetclaw/internal/version.commit=HEAD
      -X github.com/RoninForge/budgetclaw/internal/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/budgetclaw"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/budgetclaw version")
    assert_match "No activity tracked yet", shell_output("#{bin}/budgetclaw status")
  end
end
