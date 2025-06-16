class Fjira < Formula
  desc "Fuzzy-find cli jira interface"
  homepage "https://github.com/mk-5/fjira"
  url "https://github.com/mk-5/fjira/archive/refs/tags/1.4.4.tar.gz"
  sha256 "0b703334bd04d11936292e1241d9629ffca2460deb7001f78ef1911a77607165"
  license "AGPL-3.0-only"
  head "https://github.com/mk-5/fjira.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15ca4523fb54d903c23aaa42c68e7ada39b5a37dde18ccb46cbe8d5579e69113"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a6c05ff18582dc21b19c1ba3b414fbcaa661e520ba591b1a0a621ee639dba4c"
    sha256 cellar: :any_skip_relocation, ventura:       "66ac1e3ca73e11fcb1a51d943a53721b173bab5a8a338ea4489ab4be91776034"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "706a5cc113bf748e0b259876e573b6e625c7933ee71bd5870c2fc4a48b5e8286"
  end

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
