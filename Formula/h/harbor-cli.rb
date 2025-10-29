class HarborCli < Formula
  desc "CLI for Harbor container registry"
  homepage "https://github.com/goharbor/harbor-cli"
  url "https://github.com/goharbor/harbor-cli/archive/refs/tags/v0.0.14.tar.gz"
  sha256 "a0518de7b09f0aac262a556d51a149841846dc85a5a4a1eebe79b6da68b6468b"
  license "Apache-2.0"
  head "https://github.com/goharbor/harbor-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d15fc0f3a609c1133a83f55a97fe67eb6cfab5041bc7b450df733c016970076d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d15fc0f3a609c1133a83f55a97fe67eb6cfab5041bc7b450df733c016970076d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d15fc0f3a609c1133a83f55a97fe67eb6cfab5041bc7b450df733c016970076d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "281ac30f46ee7c15529986aab8021353312c1df1f8b2d7a92e2309f84d5bc400"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "391176bc847301dc92a6892249e2ca515a6f22fee1102e07e259483d82b2f55f"
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
