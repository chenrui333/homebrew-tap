class Lazyworktree < Formula
  desc "TUI for managing Git worktrees"
  homepage "https://github.com/chmouel/lazyworktree"
  url "https://github.com/chmouel/lazyworktree/archive/refs/tags/v1.52.0.tar.gz"
  sha256 "7b07fabb14605e5e75428fc30c9b61e85def9149fd745134d7b1c3c9fe94d91b"
  license "Apache-2.0"
  head "https://github.com/chmouel/lazyworktree.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b1c736cb4b708b4abfccba6f98975f97944d6099f8119c1482925c74b46e713"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b1c736cb4b708b4abfccba6f98975f97944d6099f8119c1482925c74b46e713"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d5837e64ece39a343694f314b0ed9737eb6ce116d1302988579ea208a73d436"
    sha256 cellar: :any,                 x86_64_linux:  "53eed137a790ee167e7aa1a938824b3e47868c802529f17e4527ef55755dedcf"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version} -X main.commit=homebrew -X main.builtBy=Homebrew"
    system "go", "build", *std_go_args(ldflags:, output: bin/"lazyworktree"), "./cmd/lazyworktree"

    man1.install "lazyworktree.1"
    generate_completions_from_executable(bin/"lazyworktree", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazyworktree --version")

    output = shell_output("#{bin}/lazyworktree worktrees get 2>&1", 1)
    assert_match "expected exactly one worktree argument", output
  end
end
