class Fjira < Formula
  desc "Fuzzy-find cli jira interface"
  homepage "https://github.com/mk-5/fjira"
  url "https://github.com/mk-5/fjira/archive/refs/tags/1.4.7.tar.gz"
  sha256 "fb324a5795b926375527aa920357d4093f1c7152cca01fcf70310b18e57833c4"
  license "AGPL-3.0-only"
  head "https://github.com/mk-5/fjira.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3481a51e656b1811d094decb598fbb5de09e13641db636f26c15b865da0dfe1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a645daa352530e612fccba46d8de15b01eaa02b6b8e14c466be7e6d9205fb92"
    sha256 cellar: :any_skip_relocation, ventura:       "076b28863958435ecbd6e0548319b215d6da9bd74622f51d1f807242a48fa8c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "427afd0152a5b70a62ed0812598855f6a3eef60c7803b302d91a79aabd406819"
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
