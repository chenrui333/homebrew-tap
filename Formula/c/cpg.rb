class Cpg < Formula
  desc "Cilium Policy Generator using Hubble relay"
  homepage "https://github.com/SoulKyu/cpg"
  url "https://github.com/SoulKyu/cpg/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "44597f213cc742446f962bc9b7a134ca544554d2b55de81b331580cf5623b6eb"
  license "Apache-2.0"
  head "https://github.com/SoulKyu/cpg.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e295dbc63db3e08b3aa412020880bee75c4f6ed1eb56db2daeabef7d90cddc67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e536eb8f00bfb2acce408d135d9b965b490d4cf7617242d6029b1c77d7c11b82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76fa15dcdec7a4f3b9ed24576571d7cc79a11b718afc9a63d45e8fc999fd78b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb77a1e0ca1875d1c01cd2ea09cea9ff3d70401dff217cce88b4d978f07d35b1"
    sha256 cellar: :any,                 x86_64_linux:  "6b910df33fad8ce76b8162497664e39900ae818720f0516d76478e88760e13cd"
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
