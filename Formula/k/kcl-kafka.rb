class KclKafka < Formula
  desc "Kafka swiss-army knife for producing, consuming, and administration"
  homepage "https://github.com/twmb/kcl"
  url "https://github.com/twmb/kcl/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "d5e79722fb68b2a5e4b97c5047e7fc04c5c3151a56d6cce609eb8a4f9e34eb94"
  license "BSD-3-Clause"
  head "https://github.com/twmb/kcl.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f8346d8e9b93c8d5329bae91516eaf0803513ead24dd888665bab1805e56172"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f8346d8e9b93c8d5329bae91516eaf0803513ead24dd888665bab1805e56172"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f8346d8e9b93c8d5329bae91516eaf0803513ead24dd888665bab1805e56172"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2008fb57d1ef764a049c0b26b67917c541a2f959ecd0553540ff8c5ee229d2e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89a9bba7b1cf2ced98a8ab991378b0d063df217b519cd290fb39945eaf211d39"
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
