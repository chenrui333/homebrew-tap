class Yatto < Formula
  desc "Interactive VCS-based todo-list for the command-line"
  homepage "https://github.com/handlebargh/yatto"
  url "https://github.com/handlebargh/yatto/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "cda691dffd4197295affad1486cd8f030ffdd76ee75d7391f3ab9040abbd4e43"
  license "MIT"
  head "https://github.com/handlebargh/yatto.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d5f382cfffd15a8530614316bdd60239749681f86b7203a4d08e3f98ee19ded2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5f382cfffd15a8530614316bdd60239749681f86b7203a4d08e3f98ee19ded2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5f382cfffd15a8530614316bdd60239749681f86b7203a4d08e3f98ee19ded2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "596197579f5c2ab81f9fb3516caf2339d336034a7577dc73e9e657206012e76a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ae98241d80c261427ea06e40147ed4eb994385cc70af00fa64de4f0d69ceb9f"
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
