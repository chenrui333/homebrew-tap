class GitChglog < Formula
  desc "CHANGELOG generator implemented in Go (Golang)"
  homepage "https://github.com/git-chglog/git-chglog"
  url "https://github.com/git-chglog/git-chglog/archive/refs/tags/v0.15.4.tar.gz"
  sha256 "2351cb4ca5fde61ddc844d210dc5481c7361cfb99f70f35140a57ef6cb5cb311"
  license "MIT"
  head "https://github.com/git-chglog/git-chglog.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "120a4055ec7ac1d4ef2edadb19fc787b495c1bbaf3eeec3fcef84b32caf7c4fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "738120d037bd58d018531576ba36fd072c8946723d9b456636799fa0c97d4db5"
    sha256 cellar: :any_skip_relocation, ventura:       "0093d7414ff8210b537b8aaf3bc41a67405d54f730b027361290b697d9c7b1e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "564542690498756148e45b6e3b5509dc1fd327770634e63a88f0b708db2c1691"
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
