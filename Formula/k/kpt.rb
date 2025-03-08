class Kpt < Formula
  desc "Automate Kubernetes Configuration Editing"
  homepage "https://kpt.dev/"
  url "https://github.com/kptdev/kpt/archive/refs/tags/v1.0.0-beta.56.tar.gz"
  sha256 "e5fb5a2b06c4f9e49676cfcc292be42b787c3607f75a3cf3050e829803e68c1f"
  license "Apache-2.0"
  head "https://github.com/kptdev/kpt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9bec6cf599807cf0e4663f94dbb7b34482f2bf7749dbcec60d2ac0f534702c72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e314447e42c88362fc175634813c1843cb41b2b989b5e8549c69628fb206ee3"
    sha256 cellar: :any_skip_relocation, ventura:       "1bcbc3ae0ecfb22520c595279910ba1d16aae8e1dc4c85a13e33340701a25f76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c293e860a3ee4fddb7af5b11c0c5c24aa9a3993fff2eaea818f0e6cba6b265b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/GoogleContainerTools/kpt/run.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kpt", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kpt version")

    output = shell_output("#{bin}/kpt live status 2>&1", 1)
    assert_match "error: no ResourceGroup object was provided", output
  end
end
