class Gitcredits < Formula
  desc "Turn your Git repository into movie-style rolling credits"
  homepage "https://github.com/Higangssh/gitcredits"
  url "https://github.com/Higangssh/gitcredits/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "eaeac80eb537784b554b83d33600eff93f12946cbfcdfaae65f953dd6679056d"
  license "MIT"
  head "https://github.com/Higangssh/gitcredits.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.commit=brew")
  end

  test do
    assert_match "gitcredits #{version}", shell_output("#{bin}/gitcredits --version")

    testbin = testpath/"test-bin"
    testbin.mkpath

    (testbin/"vhs").write <<~SH
      #!/bin/sh
      out=$(sed -n 's/^Output "\\(.*\\)"$/\\1/p' "$1")
      : > "$out"
    SH

    (testbin/"ffmpeg").write <<~SH
      #!/bin/sh
      for last
      do
        :
      done
      : > "$last"
    SH

    chmod 0755, [testbin/"vhs", testbin/"ffmpeg"]
    ENV.prepend_path "PATH", testbin

    repo = testpath/"repo"
    repo.mkpath
    system "git", "-C", repo, "init"
    system "git", "-C", repo, "config", "user.name", "Brew Test"
    system "git", "-C", repo, "config", "user.email", "brew@example.com"
    (repo/"README.md").write("hello\n")
    system "git", "-C", repo, "add", "README.md"
    system "git", "-C", repo, "commit", "-m", "feat: init"

    output = shell_output("cd #{repo} && #{bin}/gitcredits --output credits.gif")
    assert_match "GIF saved: credits.gif", output
    assert_path_exists repo/"credits.gif"
  end
end
