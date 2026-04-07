class Gitcredits < Formula
  desc "Turn your Git repository into movie-style rolling credits"
  homepage "https://github.com/Higangssh/gitcredits"
  url "https://github.com/Higangssh/gitcredits/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "4cf71d10bc247500eaef4bc139e0716148ddca3077d2ee1024e253d7c1d49483"
  license "MIT"
  head "https://github.com/Higangssh/gitcredits.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4f5bb1212d710994ab1ba0306db9e0fba08a37eabd3f03bbcf13bf379c0c1ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4f5bb1212d710994ab1ba0306db9e0fba08a37eabd3f03bbcf13bf379c0c1ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4f5bb1212d710994ab1ba0306db9e0fba08a37eabd3f03bbcf13bf379c0c1ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7456e42e989680195728bfafe0e35628be4b7761547a36262596300d57ca9e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "962d7772186421cd58c36eed7f7f266a89116b7cb0d955c4ce71086685680190"
  end

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
