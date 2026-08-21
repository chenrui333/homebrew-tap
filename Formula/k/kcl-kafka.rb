class KclKafka < Formula
  desc "Kafka swiss-army knife for producing, consuming, and administration"
  homepage "https://github.com/twmb/kcl"
  url "https://github.com/twmb/kcl/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "f7097158495efa8780a249408bc23a39d4315242d9ec770614f7d1d730f90877"
  license "BSD-3-Clause"
  head "https://github.com/twmb/kcl.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b08b50a4bc52bb1005a1fe9bd4985e434640b0e74230b40047d8c781ce70b053"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b08b50a4bc52bb1005a1fe9bd4985e434640b0e74230b40047d8c781ce70b053"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b08b50a4bc52bb1005a1fe9bd4985e434640b0e74230b40047d8c781ce70b053"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84986ab4e7215b29ae20492207497d1e90bdb68d004a491d9e64ead1730c25a1"
    sha256 cellar: :any,                 x86_64_linux:  "72a10a69af197180898899b360dcd683c446095e215a7c75842ccf721607e0e9"
  end

  depends_on "go" => :build

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
