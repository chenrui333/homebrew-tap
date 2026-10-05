class KclKafka < Formula
  desc "Kafka swiss-army knife for producing, consuming, and administration"
  homepage "https://github.com/twmb/kcl"
  url "https://github.com/twmb/kcl/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "1f8114af175e1ecbb65a17db5afb3099ad5300980cbc94f97df33d0af2c02767"
  license "BSD-3-Clause"
  head "https://github.com/twmb/kcl.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3fbb2ec2dfd02350126b36f133fc5f86850f4536565b9910414fc4e2fad7e87c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3fbb2ec2dfd02350126b36f133fc5f86850f4536565b9910414fc4e2fad7e87c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2fc444f0d728b29eb8fe9121e25f185d175f7ee5204aac54beac45735089934"
    sha256 cellar: :any,                 x86_64_linux:  "38a2e08149e72f7fc1a549eebbf3148faffc95601370d503bd4dc6cdf5b9bac1"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"kcl"), "."

    generate_completions_from_executable(bin/"kcl", "misc", "gen-autocomplete", shell_parameter_format: "-k")
  end

  test do
    output = shell_output("#{bin}/kcl misc errcode 3")
    assert_match "UNKNOWN_TOPIC_OR_PARTITION", output

    output = shell_output("#{bin}/kcl misc api-versions -v 3.0.0")
    assert_match "Produce", output
  end
end
