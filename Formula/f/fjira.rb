class Fjira < Formula
  desc "Fuzzy-find cli jira interface"
  homepage "https://github.com/mk-5/fjira"
  url "https://github.com/mk-5/fjira/archive/refs/tags/1.4.6.tar.gz"
  sha256 "27510e7002f8df5640275f9488eb99682c160b15735caa3f41e05625583b7cf3"
  license "AGPL-3.0-only"
  head "https://github.com/mk-5/fjira.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35ec678692a0b5d2c9deac1685d2838c502e240c9f20af6d8cb6675aa7f34d03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf8d2be6741f3c65e1d7c1c0d32fa64a7f7d53b173b30750b66e8390452231d7"
    sha256 cellar: :any_skip_relocation, ventura:       "a13f5ddbea8f3397f5214ebe358c533bd76e31672b01379e695ad1161361870e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d44da3b016a9916b2bef10302537d73e6449ec40f30b202a40969157f83195a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/fjira-cli"

    generate_completions_from_executable(bin/"fjira", "completion", shells: [:bash, :zsh, :fish, :pwsh])
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
