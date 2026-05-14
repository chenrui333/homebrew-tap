class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.11.6.tar.gz"
  sha256 "fd6c1e85ec353d14676e4de65589188bbb75f0b7e668653c6215923c001dda28"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d314c6c8afb00ae407473612f0a35ef429d762157b471654f7d9e8fec0ce3325"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d314c6c8afb00ae407473612f0a35ef429d762157b471654f7d9e8fec0ce3325"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d314c6c8afb00ae407473612f0a35ef429d762157b471654f7d9e8fec0ce3325"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0bea262f46beb82155e891b1e5f24da15de52ac60e95c0caa006417550eb4ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72fb9d3235f8665b598b578037af9f124b32e8ed1b0694681e6ca2adea280d64"
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
