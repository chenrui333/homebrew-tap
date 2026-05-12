class Yatto < Formula
  desc "Interactive VCS-based todo-list for the command-line"
  homepage "https://github.com/handlebargh/yatto"
  url "https://github.com/handlebargh/yatto/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "a39473692e77ef0ac98f4b1aa43a8743d6fb26885c0d63f70c8d440876fdbd64"
  license "MIT"
  head "https://github.com/handlebargh/yatto.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c63c86ba886e87141dbda83d2609d02c49f748b7858470e1929201176a2b8b33"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c63c86ba886e87141dbda83d2609d02c49f748b7858470e1929201176a2b8b33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c63c86ba886e87141dbda83d2609d02c49f748b7858470e1929201176a2b8b33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d422029440d6ddd8e51a99118e2266cfb502989e42743b365a801c5bda470e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a6554ba9e658e01ead25e160de894a690561ae112f111d3818aa84bb7895ec9"
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
