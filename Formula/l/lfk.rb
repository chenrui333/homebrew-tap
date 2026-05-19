class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "d3d8b4f122bbf977642609ebbda8d052fb85e9f2c5cf79461372717205990d53"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7232bb8b7b2433a59cef7f50cc1d3459952a66157a9e17f8de026d26218cc3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7232bb8b7b2433a59cef7f50cc1d3459952a66157a9e17f8de026d26218cc3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7232bb8b7b2433a59cef7f50cc1d3459952a66157a9e17f8de026d26218cc3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce17b8707615f2fd3abb0e2240b9d5233997c84c367469dfa0a5c4bf1ddbc218"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "900c1db4b7e750997b09befc170701c733d3ae0c24c44cdb0f21a7365e53f264"
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
