class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.13.7.tar.gz"
  sha256 "762967e25b4060f213ef1f8c3654e45dfdd9e97d313e054a4f60d4b3813dede6"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5e7cfa7790f5adc8a5560bd6ccaf569c3a52c5d0513f804b1d99035bc6d219e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5e7cfa7790f5adc8a5560bd6ccaf569c3a52c5d0513f804b1d99035bc6d219e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5e7cfa7790f5adc8a5560bd6ccaf569c3a52c5d0513f804b1d99035bc6d219e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83f115ae4ee33bd00486c6cced9ab37c96ea7a85ceef63ad1d4f2048bc56d8fa"
    sha256 cellar: :any,                 x86_64_linux:  "0fe93253a2f0d082aa18ba6474600fcd6c7fd90d5bd14ce029d297da68ec9d0b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/janosmiko/lfk/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "."

    generate_completions_from_executable(bin/"lfk", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lfk --version 2>&1")
    assert_match "#compdef lfk", shell_output("#{bin}/lfk completion zsh")
  end
end
