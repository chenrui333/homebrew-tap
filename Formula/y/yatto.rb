class Yatto < Formula
  desc "Interactive VCS-based todo-list for the command-line"
  homepage "https://github.com/handlebargh/yatto"
  url "https://github.com/handlebargh/yatto/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "a39473692e77ef0ac98f4b1aa43a8743d6fb26885c0d63f70c8d440876fdbd64"
  license "MIT"
  head "https://github.com/handlebargh/yatto.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a557666ab597025d7d7366f053ae0f9eb6a006cb5e38ff2424fcf99fe8dbebb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a557666ab597025d7d7366f053ae0f9eb6a006cb5e38ff2424fcf99fe8dbebb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "860405afa82bc458de9296c1b32d584871c627b3322f91484b0d8441971858bb"
    sha256 cellar: :any,                 x86_64_linux:  "c30e1612a9d9f7bb6cb449fb42691bedf9c324e9c95290a16db508134e07546c"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
