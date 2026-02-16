class Yatto < Formula
  desc "Interactive VCS-based todo-list for the command-line"
  homepage "https://github.com/handlebargh/yatto"
  url "https://github.com/handlebargh/yatto/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "af873ab0fc58251f62cde7e6813eec979e3b84edf148ab8bf701459356db8e0f"
  license "MIT"
  head "https://github.com/handlebargh/yatto.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bbffe5c5bde47421c75197edd837cc2f117b190a3181c3332dd536d82704b2dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bbffe5c5bde47421c75197edd837cc2f117b190a3181c3332dd536d82704b2dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bbffe5c5bde47421c75197edd837cc2f117b190a3181c3332dd536d82704b2dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a005e76bafa531e68e7de2db9e1819221328f60873808c5b4167004a0a41b240"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91a644acb704a4e01b93ea2b31e0ea89553f1a781260e5b3420266d8d03168cb"
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
