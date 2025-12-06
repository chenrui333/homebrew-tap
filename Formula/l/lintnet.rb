# framework: urfave/cli
class Lintnet < Formula
  desc "General purpose linter for structured configuration data powered by Jsonnet"
  homepage "https://lintnet.github.io/"
  url "https://github.com/lintnet/lintnet/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "c5286cc799333898c1fc74cc27c22a779a6679438fe669351f31236d485e312e"
  license "MIT"
  head "https://github.com/lintnet/lintnet.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96f2e62c5d0a97c9eb3dd018ed2f699c1d3c97d600ed374c632298b5b595e230"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23333d0ce051a3c40b30064801e827c6156b1790e352c13f3593daa0eafae82f"
    sha256 cellar: :any_skip_relocation, ventura:       "3baee84033a4e5dad880f7107b1aa77a067ffb843204f181f63833e778a1f8de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aaca4d81531e9135707ec48cc5ab9e320ca0ce8430da1fbfe39d5994414e11d3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/lintnet"

    generate_completions_from_executable(bin/"lintnet", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lintnet version")
    assert_match version.to_s, JSON.parse(shell_output("#{bin}/lintnet info"))["version"]

    system bin/"lintnet", "init"
    assert_match "A configuration file of lintnet", (testpath/"lintnet.jsonnet").read
  end
end
