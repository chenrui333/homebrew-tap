class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v0.46.3.tar.gz"
  sha256 "1f0729dc825a982ac48819f7fe36748c43fa3227a6261070f1ac1d9c05466a3f"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0376053f7cc199383d15796bdf6d864c486442ffacac64e2cb00b1dcfe0cbc76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9620c92d9177e75e2bc21263495291881ee73313c4315e8d653fb4cd630e0eab"
    sha256 cellar: :any_skip_relocation, ventura:       "d23d0b5e7ffaa96c526cdd0ab6b40a8734723f4b5bcb700694cc63adff0714d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0dbe267069eb8b7663d89815c633e5a533f60225a662ddd33c94dc34ec99e54e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/omnictl"

    generate_completions_from_executable(bin/"omnictl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/omnictl --version")

    system bin/"omnictl", "config", "new"
    assert_match "Current context: default", shell_output("#{bin}/omnictl config info")

    output = shell_output("#{bin}/omnictl cluster status test 2>&1", 1)
    assert_match "connect: connection refused", output
  end
end
