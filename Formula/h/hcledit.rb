# framework: cobra
class Hcledit < Formula
  desc "Command-line editor for HCL"
  homepage "https://github.com/minamijoyo/hcledit"
  url "https://github.com/minamijoyo/hcledit/archive/refs/tags/v0.2.16.tar.gz"
  sha256 "fc7a91a11b0dcba039d34425f5acd4f786824a58c39e53aa6c553097287532bc"
  license "MIT"
  head "https://github.com/minamijoyo/hcledit.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "092d63829aa7a5ca6d8a562c60aa70cec14c5f7e8e7831fc6898195d420663da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b57ffadb9b5e227000d995399da0822c816718c9a9ef99deea06797f3dc3136a"
    sha256 cellar: :any_skip_relocation, ventura:       "bd3c37ca124c4f161c0c22dc287b533ce374bfec552f4aa7930adf64cdfde0ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d899f9bf01b7252b104d6c0b7416024c064534410119e1ad024e38a4a4925486"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/minamijoyo/hcledit/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hcledit version")

    (testpath/"test.hcl").write <<~HCL
      resource "foo" "bar" {
        attr1 = "val1"
        nested {
          attr2 = "val2"
        }
      }
    HCL

    output = pipe_output("#{bin}/hcledit attribute get resource.foo.bar.attr1",
                        (testpath/"test.hcl").read, 0)
    assert_equal "\"val1\"", output.chomp
  end
end
