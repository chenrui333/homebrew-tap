class Yatto < Formula
  desc "Interactive VCS-based todo-list for the command-line"
  homepage "https://github.com/handlebargh/yatto"
  url "https://github.com/handlebargh/yatto/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "47e301b85b24f92305f0f7d5cb5786d762ff01267a29c4da743ddae98bb65f1f"
  license "MIT"
  head "https://github.com/handlebargh/yatto.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d17039a92c3b76fad6edb8fcd620f218d91b4ddb8afd29a25a1b005501c7decf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d17039a92c3b76fad6edb8fcd620f218d91b4ddb8afd29a25a1b005501c7decf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d17039a92c3b76fad6edb8fcd620f218d91b4ddb8afd29a25a1b005501c7decf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad07f871216df42150b7703686ba1bb48013242e5d6a44b50f974d8dba2f0ab8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80fa0d4378749d240c31fd6e664649e516dcf3c1df3dc1997c2216b3588dd556"
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
