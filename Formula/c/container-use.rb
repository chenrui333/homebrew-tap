class ContainerUse < Formula
  desc "Dev envs for coding agents. Run multiple agents safely with your stack"
  homepage "https://github.com/dagger/container-use"
  url "https://github.com/dagger/container-use/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "951105f0b4a9bfd9f52e7bb3a2d245e800df4b8449704cd34001833ee888a02d"
  license "Apache-2.0"
  head "https://github.com/dagger/container-use.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea9bd98957f36c9967c0ab8a0cd0f40fd2d78d54ee7840f0b4ffb9738bf8542f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73d65cc49392cd39df8e826c9566c8ba8907650c7ed201e57d02c6dc01c73e26"
    sha256 cellar: :any_skip_relocation, ventura:       "722fa1ccc22e15244fb675d0fd741a2f2a72a654df6855516814cdaa24822713"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f52d03d1df5f353946af532c89f4fcd60d48a3ab1c9fbd721bc5bf0d47f2ec57"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/container-use"

    generate_completions_from_executable(bin/"container-use", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/container-use version 2>&1")

    system "git", "init"
    assert_match "No environment variables configured", shell_output("#{bin}/container-use config env list")
  end
end
