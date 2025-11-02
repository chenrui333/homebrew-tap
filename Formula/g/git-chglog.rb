class GitChglog < Formula
  desc "CHANGELOG generator implemented in Go (Golang)"
  homepage "https://github.com/git-chglog/git-chglog"
  url "https://github.com/git-chglog/git-chglog/archive/refs/tags/v0.15.4.tar.gz"
  sha256 "2351cb4ca5fde61ddc844d210dc5481c7361cfb99f70f35140a57ef6cb5cb311"
  license "MIT"
  revision 1
  head "https://github.com/git-chglog/git-chglog.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1bd925147de128df5754c33d1aa1c6e945c2fee45c755d6aab772751f005a5b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1bd925147de128df5754c33d1aa1c6e945c2fee45c755d6aab772751f005a5b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1bd925147de128df5754c33d1aa1c6e945c2fee45c755d6aab772751f005a5b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b68002b29adba5cd907a8aee51c8e231a6836ed4e27f4dc14ba604f3421b6d7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcd057cdb0dd4faa37b2ba141c8d0a6e0e9735782cd087d0a63bfd02ef1c17db"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/git-chglog"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-chglog --version")

    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "test@brew.sh"

    (testpath/"README.md").write("# test")
    system "git", "add", "README.md"
    system "git", "commit", "-m", "Initial commit"

    system "git", "tag", "v0.1.0"

    (testpath/".chglog/config.yml").write <<~EOS
      template: CHANGELOG.tpl.md
      data:
        repository_url: "https://github.com/test/test"
    EOS

    (testpath/".chglog/CHANGELOG.tpl.md").write <<~EOS
      {{ range .Versions }}
      ## {{ .Tag.Name }}
      {{ range .CommitGroups }}
      ### {{ .Title }}
      {{ range .Commits }}
      - {{ .Subject }}
      {{ end }}
      {{ end }}
      {{ end }}
    EOS

    output = shell_output("#{bin}/git-chglog")
    assert_match "## v0.1.0", output
  end
end
