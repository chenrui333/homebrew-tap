class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "195325f91b6baad77e3715a4ce9acf463e91feec906f99709eb342f3bb52584e"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b277074bfcd9824d7a8ed507743b47563abf069bc86a80bedffe9fb470321909"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b277074bfcd9824d7a8ed507743b47563abf069bc86a80bedffe9fb470321909"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b277074bfcd9824d7a8ed507743b47563abf069bc86a80bedffe9fb470321909"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5158aa76163981f148d95329f92c4eb643981ba87c0f3f0d52f6d59114e12f4e"
    sha256 cellar: :any,                 x86_64_linux:  "4ad6b0aa0a1dde04e6b22dde088d97deadd8616d2a39a67ae1f5e93457bc92ad"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/janosmiko/lfk/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "."

    generate_completions_from_executable(bin/"lfk", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lfk --version 2>&1")
    output = shell_output("#{bin}/lfk not-a-real-command 2>&1", 1)
    assert_match "unknown command", output
  end
end
