class Yatto < Formula
  desc "Interactive VCS-based todo-list for the command-line"
  homepage "https://github.com/handlebargh/yatto"
  url "https://github.com/handlebargh/yatto/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "47e301b85b24f92305f0f7d5cb5786d762ff01267a29c4da743ddae98bb65f1f"
  license "MIT"
  head "https://github.com/handlebargh/yatto.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5d98ca1a1b0a2ccf523b60d2241d684f8484423dd305d07e9e87a31f31f658f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5d98ca1a1b0a2ccf523b60d2241d684f8484423dd305d07e9e87a31f31f658f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5d98ca1a1b0a2ccf523b60d2241d684f8484423dd305d07e9e87a31f31f658f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6af765756ed187f0ece3293a942f54c5881a892343fc5be683c116785b8388a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98747baee4b29c3807e697b8882368f6da40894e4cc8a58d9734c26e4ce19c63"
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
