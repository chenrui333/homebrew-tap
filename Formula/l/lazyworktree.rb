class Lazyworktree < Formula
  desc "TUI for managing Git worktrees"
  homepage "https://github.com/chmouel/lazyworktree"
  url "https://github.com/chmouel/lazyworktree/archive/refs/tags/v1.52.0.tar.gz"
  sha256 "7b07fabb14605e5e75428fc30c9b61e85def9149fd745134d7b1c3c9fe94d91b"
  license "Apache-2.0"
  head "https://github.com/chmouel/lazyworktree.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0d96edeb782afe768156bfee84edc5fe91cb2b80c4828292ef4d51ba670cc4d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0d96edeb782afe768156bfee84edc5fe91cb2b80c4828292ef4d51ba670cc4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07c01aafa894b3853e8aa1ca8fd8e60c3517570afa66d80f6c6ddf651e6106fb"
    sha256 cellar: :any,                 x86_64_linux:  "c960b03849264f1a3d78c5ac13a3f048321da7f7dd9330f8a5168598aca8e361"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=homebrew -X main.builtBy=Homebrew"
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
