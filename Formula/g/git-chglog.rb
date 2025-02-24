class GitChglog < Formula
  desc "CHANGELOG generator implemented in Go (Golang)"
  homepage "https://github.com/git-chglog/git-chglog"
  url "https://github.com/git-chglog/git-chglog/archive/refs/tags/v0.15.4.tar.gz"
  sha256 "2351cb4ca5fde61ddc844d210dc5481c7361cfb99f70f35140a57ef6cb5cb311"
  license "MIT"
  head "https://github.com/git-chglog/git-chglog.git", branch: "master"

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
