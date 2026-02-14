class Yatto < Formula
  desc "Interactive VCS-based todo-list for the command-line"
  homepage "https://github.com/handlebargh/yatto"
  url "https://github.com/handlebargh/yatto/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "2c3d3d9d5b97686441ce5ec89bf1a9204744b2c5fb53cd9b0eec6d2e4d699c80"
  license "MIT"
  head "https://github.com/handlebargh/yatto.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "318c1a22636956d452118f208d6b6f88e20c2f5980517f1c1edb717087912960"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "318c1a22636956d452118f208d6b6f88e20c2f5980517f1c1edb717087912960"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "318c1a22636956d452118f208d6b6f88e20c2f5980517f1c1edb717087912960"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85d220adeca1f17954135a889069a89b99f765ece79f513496aa7206ed024cc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e26d6fabcd945e0104b4c97f9d5343b306aac1efc47179782190a256a7d04b87"
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
