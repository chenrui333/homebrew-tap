class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.11.3.tar.gz"
  sha256 "db68bf35e824d24b97f01a4f1604f7b365e87c4dc4371bbeea7ddef4622b2d24"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68574737ea37f0ad7d738bb3d8ebf66d5237f0408a55eada16497a34d27affb5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68574737ea37f0ad7d738bb3d8ebf66d5237f0408a55eada16497a34d27affb5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68574737ea37f0ad7d738bb3d8ebf66d5237f0408a55eada16497a34d27affb5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11348632f95385d067ec1fe66194cd5daf0fda08c8b0c85fe4be25ad5b892e99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "928b1e917def9eb331201c211e3ed29b20d63cdc00f845cd24e83d1655312c7e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/janosmiko/lfk/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "."

    generate_completions_from_executable(bin/"lfk", "completion", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lfk --version 2>&1")
    assert_match "#compdef lfk", shell_output("#{bin}/lfk completion zsh")
  end
end
