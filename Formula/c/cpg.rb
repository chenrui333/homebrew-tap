class Cpg < Formula
  desc "Cilium Policy Generator using Hubble relay"
  homepage "https://github.com/SoulKyu/cpg"
  url "https://github.com/SoulKyu/cpg/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "44597f213cc742446f962bc9b7a134ca544554d2b55de81b331580cf5623b6eb"
  license "Apache-2.0"
  head "https://github.com/SoulKyu/cpg.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "972fb4be03a240dca4d3b1f5cfde3df1071d183adbf49ea69a8fefdf3d42ad4c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65939dfdb68c3bb97cbd9dddb9e8f1ac1c273cb4ccc08861452f806ae6f053df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b37dbc4eb99eff71f839867c5bb80c58e6a7a3bb25cd2ebbdea9a043ba018a30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20603988c13bc6c7a0cebd18d00b60cd30145b14a12ec88cad9fd52cabc6340d"
    sha256 cellar: :any,                 x86_64_linux:  "f1ec25a6161f03a23a1bb2bbf0378023bc3a96fc34c1966d21c1718273cf77c7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/cpg"

    generate_completions_from_executable(bin/"cpg", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cpg --version")
  end
end
