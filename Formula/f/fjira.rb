class Fjira < Formula
  desc "Fuzzy-find cli jira interface"
  homepage "https://github.com/mk-5/fjira"
  url "https://github.com/mk-5/fjira/archive/refs/tags/1.4.4.tar.gz"
  sha256 "0b703334bd04d11936292e1241d9629ffca2460deb7001f78ef1911a77607165"
  license "AGPL-3.0-only"
  head "https://github.com/mk-5/fjira.git", branch: "master"

  depends_on "go" => :build

  patch do
    url "https://raw.githubusercontent.com/chenrui333/homebrew-tap/be741a8f29e7db039b73b5e88962792ac226393c/patches/fjira/1.4.4.patch"
    sha256 "8b5598a2fa87542feb7aaf658d6aaa5caffbdb341158e0af2ca75d0a4a8e0910"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/fjira-cli"

    generate_completions_from_executable(bin/"fjira", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fjira version")

    output_log = testpath/"output.log"
    pid = spawn bin/"fjira", testpath, [:out, :err] => output_log.to_s
    sleep 1
    assert_match "Create new workspace default", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
