class KclKafka < Formula
  desc "Kafka swiss-army knife for producing, consuming, and administration"
  homepage "https://github.com/twmb/kcl"
  url "https://github.com/twmb/kcl/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "1f8114af175e1ecbb65a17db5afb3099ad5300980cbc94f97df33d0af2c02767"
  license "BSD-3-Clause"
  head "https://github.com/twmb/kcl.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "01a8a374cbfb32a72b177030854c829e910a154e74948d361f2910eab56da2a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01a8a374cbfb32a72b177030854c829e910a154e74948d361f2910eab56da2a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db35a3e448ca5739afff5721053cd40f03c5afb6f98eadfccb7970c9aeb8d0ca"
    sha256 cellar: :any,                 x86_64_linux:  "e27eef1cb6a282e0f37ca3ad2cf42e760da44c245653b51b166ab728c32172af"
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
