class Cpg < Formula
  desc "Cilium Policy Generator using Hubble relay"
  homepage "https://github.com/SoulKyu/cpg"
  url "https://github.com/SoulKyu/cpg/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "86d72e76a193fbf4019d81d231528a4b412ad7b800f0dbda3a640c60cbd68465"
  license "Apache-2.0"
  head "https://github.com/SoulKyu/cpg.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "66ab5bfb717fc493ff179f3ffaee4e3c1d1bcdf4506680909a32c98f05b1b5c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4bfbfd7e6b7abe7bdad4035df576f47c14ebdd81be41f9ab204dab4dac3c45d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5298807bd33a21f9a42332ceb4d12bc9117f4eea28f2379ab3666b9566e84ffa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f739e218689647376fc289b496d272daf5c9b78d6df67fc4c7d275ef88094747"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc0ca9eb59c0be53f92fd4ed1071018448158e31c0fa13c6e419457b7d32bcfe"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/cpg"

    generate_completions_from_executable(bin/"cpg", "completion", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cpg --version")
  end
end
