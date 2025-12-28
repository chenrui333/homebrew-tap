class Fli < Formula
  desc "CLI for AWS VPC Flow Logs analysis"
  homepage "https://github.com/fractalops/fli"
  url "https://github.com/fractalops/fli/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "4b3c7c454fef762209b4fe879e205ecbc51126625172675ad1ea8f60dc47df82"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "633cf439b73645f8fe2ad1b6234e39dd652fb883b85f5d8eb869d4a6c047bae5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "633cf439b73645f8fe2ad1b6234e39dd652fb883b85f5d8eb869d4a6c047bae5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "633cf439b73645f8fe2ad1b6234e39dd652fb883b85f5d8eb869d4a6c047bae5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b07819c91a59806c55bbeb6f25ebecb2b23d4d6760487f5cc696e45466ff8b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e723483b8b40dbcc46bc61199c04d7c32f484e96432d6a976205685c425b59ba"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/fli"

    generate_completions_from_executable(bin/"fli", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/fli --dry-run count --by srcaddr --since 1h --log-group test")
    assert_match "FLI Query Configuration", output
  end
end
