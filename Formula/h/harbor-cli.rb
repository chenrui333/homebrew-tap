class HarborCli < Formula
  desc "CLI for Harbor container registry"
  homepage "https://github.com/goharbor/harbor-cli"
  url "https://github.com/goharbor/harbor-cli/archive/refs/tags/v0.0.14.tar.gz"
  sha256 "a0518de7b09f0aac262a556d51a149841846dc85a5a4a1eebe79b6da68b6468b"
  license "Apache-2.0"
  head "https://github.com/goharbor/harbor-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "232fa58aa037d1a7c56e7f7ea59cf4e9b856efceac361fa57b5014e508071ac2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "232fa58aa037d1a7c56e7f7ea59cf4e9b856efceac361fa57b5014e508071ac2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "232fa58aa037d1a7c56e7f7ea59cf4e9b856efceac361fa57b5014e508071ac2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1727c6374374aab348b296b0380f486950a2cdfad72eb7cbabd9213854499ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fc505f39ce7035c373fe844f4324921a1e40709941c18f1ca8fd3f3d578b5f3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/goharbor/harbor-cli/cmd/harbor/internal/version.Version=#{version}
      -X github.com/goharbor/harbor-cli/cmd/harbor/internal/version.GoVersion=#{Formula["go"].version}
      -X github.com/goharbor/harbor-cli/cmd/harbor/internal/version.GitCommit=#{tap.user}
      -X github.com/goharbor/harbor-cli/cmd/harbor/internal/version.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"harbor"), "./cmd/harbor"

    generate_completions_from_executable(bin/"harbor", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/harbor version")

    output = shell_output("#{bin}/harbor repo list 2>&1", 1)
    assert_match "Error: failed to get project name", output
  end
end
