class Yatto < Formula
  desc "Interactive VCS-based todo-list for the command-line"
  homepage "https://github.com/handlebargh/yatto"
  url "https://github.com/handlebargh/yatto/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "8e1fb414d1fd12885c4445fbea5129748f535c406ffb9a0f036cc56c04f672ac"
  license "MIT"
  head "https://github.com/handlebargh/yatto.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2014c83736892106af632a5de3bc34af03800c699706a11af93f9555ecfbb538"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2014c83736892106af632a5de3bc34af03800c699706a11af93f9555ecfbb538"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2014c83736892106af632a5de3bc34af03800c699706a11af93f9555ecfbb538"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb16f1d9a51ee7332fd1dc47420ae65fd709fe22ce5851f374cbcf4edcb1e0f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e51a2169bec8d9fd0827d98d69b9b29633ce342e114f19a95b87c67fff5cf5c0"
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
