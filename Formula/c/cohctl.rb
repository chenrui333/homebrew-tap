# framework: cobra
class Cohctl < Formula
  desc "CLI for Coherence clusters"
  homepage "https://followtheprocess.github.io/spok/"
  url "https://github.com/oracle/coherence-cli/archive/refs/tags/1.10.1.tar.gz"
  sha256 "e6c59886b34a9a4afb0a46f8b837483bf5e7d4b96bec4d5e4dd4eb1af0da30ac"
  license "UPL-1.0"
  head "https://github.com/oracle/coherence-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0eaca74081d57bc7970be34097d91411ebfe96379fe586b5c4a557eb33d2610"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99e5cdb2ca9be0a6fa14d23ab4f9bbf66e64ab7ca8a92df1743026d346ec9acf"
    sha256 cellar: :any_skip_relocation, ventura:       "5eb600a34754d2a533ae871c8c69c3fb3c932be61de68137d0b3f39900e41fe8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea45512feb24c79d30cb4e5a11f1bda1f5767c077e9b0724f0f16db4d8f7f2c3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.Commit=#{tap.user} -X main.Date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cohctl"

    generate_completions_from_executable(bin/"cohctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cohctl version")

    output = shell_output("#{bin}/cohctl describe cluster test 2>&1", 1)
    assert_match "unable to find cluster with connection name test", output
  end
end
