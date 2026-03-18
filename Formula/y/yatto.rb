class Yatto < Formula
  desc "Interactive VCS-based todo-list for the command-line"
  homepage "https://github.com/handlebargh/yatto"
  url "https://github.com/handlebargh/yatto/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "1ae4ff38e15638866e6ae72f6457ba6cb68be419fc631ec967e35d266e5a5427"
  license "MIT"
  head "https://github.com/handlebargh/yatto.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dee923a94534933afb29c74a54b4abb0d9233edf3ef147f2d34d250732101891"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dee923a94534933afb29c74a54b4abb0d9233edf3ef147f2d34d250732101891"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dee923a94534933afb29c74a54b4abb0d9233edf3ef147f2d34d250732101891"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4211ed52bceb893b4f7d11b1df17460508e4ebc93665547b25e010764709a0df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e47f72d4be350a341022a9b3f35585163d4230cac0b7dcc963a812d457c87b2f"
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
