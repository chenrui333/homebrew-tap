class Gitsocial < Formula
  desc "Git-native cross-forge collaboration platform"
  homepage "https://github.com/gitsocial-org/gitsocial"
  url "https://github.com/gitsocial-org/gitsocial/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "cad975da9a0f47c7db35e04854c1a7a455eadb6a16d02412a9a819c6d77c0728"
  license "MIT"
  head "https://github.com/gitsocial-org/gitsocial.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "46c0490c0edea382e1d15fe4cc76519925cd7b4e0686930b4eec60af2b4672f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46c0490c0edea382e1d15fe4cc76519925cd7b4e0686930b4eec60af2b4672f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46c0490c0edea382e1d15fe4cc76519925cd7b4e0686930b4eec60af2b4672f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ddeaac72d38853cbd4a1093453d8e6941d008f64904dce972aac3957e91330fc"
    sha256 cellar: :any,                 x86_64_linux:  "70563e9d123c10e7cc57ab0e89ddaf1876784174f4aa25432101ee0a45dca258"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cli/gitsocial"

    generate_completions_from_executable(bin/"gitsocial", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitsocial --version 2>&1")
  end
end
