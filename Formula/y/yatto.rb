class Yatto < Formula
  desc "Interactive VCS-based todo-list for the command-line"
  homepage "https://github.com/handlebargh/yatto"
  url "https://github.com/handlebargh/yatto/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "0b0652d79fbe2ff3708baa768cb5c834aa1d6ef96888371540d1620af208cd7e"
  license "MIT"
  head "https://github.com/handlebargh/yatto.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ffdae19effb7ab658e17dc976df320ede48582fda676f1a17d01c78783b3382d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ffdae19effb7ab658e17dc976df320ede48582fda676f1a17d01c78783b3382d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ffdae19effb7ab658e17dc976df320ede48582fda676f1a17d01c78783b3382d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55ef579d01cb774eeb0dcacc74d5ce9804d4bbbe3765aa35e587f0bb6798ff7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4d2f510d3833f317574c4ce1d6088f35878657e3621767fd1b5389d1560d2a8"
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

    generate_completions_from_executable(bin/"yatto", shell_parameter_format: :cobra)
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
