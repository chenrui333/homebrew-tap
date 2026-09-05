class Tenderly < Formula
  desc "Debugging, monitoring & tracking smart contract execution"
  homepage "https://github.com/Tenderly/tenderly-cli"
  url "https://github.com/Tenderly/tenderly-cli/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "202ff6987768010c68380587f1bd665cecd12c5fbdb935718d38c4ed081b5791"
  license "GPL-3.0-only"
  head "https://github.com/Tenderly/tenderly-cli.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9772a477ce82738ab0c749886eede7691ff01040beaa606bb0ec32601ac86c1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9772a477ce82738ab0c749886eede7691ff01040beaa606bb0ec32601ac86c1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9772a477ce82738ab0c749886eede7691ff01040beaa606bb0ec32601ac86c1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd6b02446ccfacb9bf1f11cd80940cd381f32b3c891d5a0e20778582aaaceb0c"
    sha256 cellar: :any,                 x86_64_linux:  "5c36c88ba00da28714fc74a5c54de020d43962c8fc721d10422262f034a16bd8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"tenderly", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tenderly version")

    output = shell_output("#{bin}/tenderly init 2>&1", 1)
    assert_match "configuration was not detected", output
  end
end
