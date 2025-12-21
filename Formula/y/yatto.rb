class Yatto < Formula
  desc "Interactive VCS-based todo-list for the command-line"
  homepage "https://github.com/handlebargh/yatto"
  url "https://github.com/handlebargh/yatto/archive/refs/tags/v0.21.8.tar.gz"
  sha256 "9c2ca739df952608dd8e6441ee7fce4702ae219bb3608e047f740af6c0460e85"
  license "MIT"
  head "https://github.com/handlebargh/yatto.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "753ead63fdfe9898fc4dc8cde9ffa8a41f44b30ca7b922d5f68aff6ea91ceaa3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "753ead63fdfe9898fc4dc8cde9ffa8a41f44b30ca7b922d5f68aff6ea91ceaa3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "753ead63fdfe9898fc4dc8cde9ffa8a41f44b30ca7b922d5f68aff6ea91ceaa3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "596573a06d1f29358b39c14fcc36e874ef18814fd22efd0159ead65367cac12e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "113aff2b0addada39bc919bab7a9e95070d118e57569fdefbdf865b6ab913da6"
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

    generate_completions_from_executable(bin/"yatto", "completion", shells: [:bash, :zsh, :fish, :pwsh])
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
