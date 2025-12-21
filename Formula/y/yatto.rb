class Yatto < Formula
  desc "Interactive VCS-based todo-list for the command-line"
  homepage "https://github.com/handlebargh/yatto"
  url "https://github.com/handlebargh/yatto/archive/refs/tags/v0.21.9.tar.gz"
  sha256 "bdfcccd24d50939b950a7f5ffb0a99ef4fb9579cce5de9032db29bfb498842fc"
  license "MIT"
  head "https://github.com/handlebargh/yatto.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f4ef1c756f1a9d0f144a0faf37289813ac568d7b3791e4417e398cfe5995d265"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4ef1c756f1a9d0f144a0faf37289813ac568d7b3791e4417e398cfe5995d265"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4ef1c756f1a9d0f144a0faf37289813ac568d7b3791e4417e398cfe5995d265"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b188dc799061aef214a2dc27881fc5ad43607f1ca6a218eb4d58cbcaa6415e83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95f53e374bc6b7af94f4c893ef08bc7abb97b5879830ef6fd85515e7a6fa235b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/handlebargh/yatto/internal/version.version=#{version}
      -X github.com/handlebargh/yatto/internal/version.revision=#{tap.user}
      -X github.com/handlebargh/yatto/internal/version.revisionDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"yatto", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    # assert_match version.to_s, shell_output("#{bin}/yatto version")
    # Version:	(devel)
    # Revision:	chenrui333
    # RevisionDate:	2025-11-17T17:30:31Z
    # GoVersion:	go1.25.4
    system bin/"yatto", "version"

    (testpath/".config/yatto/config.toml").write <<~TOML
      [git]
      default_branch = 'main'

      [git.remote]
      enable = true
      name = 'origin'
      url = 'chenrui333/homebrew-tap'
    TOML
    output = shell_output("#{bin}/yatto config show")
    assert_match "[git]\ndefault_branch = 'main'", output
  end
end
