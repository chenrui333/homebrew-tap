class Fjira < Formula
  desc "Fuzzy-find cli jira interface"
  homepage "https://github.com/mk-5/fjira"
  url "https://github.com/mk-5/fjira/archive/refs/tags/1.4.8.tar.gz"
  sha256 "8ae74e699824bf657a183f0e4a4d553f73604c214201e4928b1bb46518c9f3d2"
  license "AGPL-3.0-only"
  head "https://github.com/mk-5/fjira.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19f19457552ee516a540a344e2034fd2794adefa4c23e517dea3037ef7d0d3dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4866edd7b5b2805469da9da0da0e1904664c86aa4e18e2abe094ea45a819b220"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "237ec091ca66125e26178a647d8ed852f0f39a103b007d010457021852be48d2"
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
