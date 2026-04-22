class KclKafka < Formula
  desc "Kafka swiss-army knife for producing, consuming, and administration"
  homepage "https://github.com/twmb/kcl"
  url "https://github.com/twmb/kcl/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "3c434446e39401af0825067e6b334efe5dea43fa7edeff1d7666dfe35f379bc5"
  license "BSD-3-Clause"
  head "https://github.com/twmb/kcl.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "84d76c5df3c4d57dae374c44a1252affc7fd32edc7f026d06d3779868bc694bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84d76c5df3c4d57dae374c44a1252affc7fd32edc7f026d06d3779868bc694bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84d76c5df3c4d57dae374c44a1252affc7fd32edc7f026d06d3779868bc694bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c707c0a257c100b1f40313ad46e9086a8ee4f65e8a62cdb7dbee85f758b72a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2de44dabc7fae46f913ec4cbf7de42a3635cff778098cec81beb3038f4744f92"
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
