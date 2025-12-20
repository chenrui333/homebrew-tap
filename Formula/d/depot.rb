class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.101.0.tar.gz"
  sha256 "2e69bf9263de9003d934a40887d45c4ceeef1a7339f0ee61e329dd5fdfae7ab6"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89dacfeb3ebd88897601d61220de09ee5adbafc2112b350129996f8c49ed431d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89dacfeb3ebd88897601d61220de09ee5adbafc2112b350129996f8c49ed431d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89dacfeb3ebd88897601d61220de09ee5adbafc2112b350129996f8c49ed431d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc6bf80b084dd2eb52154fb1422ba5ade6195928f3bd6d561dbf1569a3712f5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fbc5f956e8ad243be1a99496bfb93cfb75ad467b509893a996c0b00073d57aa"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/depot/cli/internal/build.Version=#{version}
      -X github.com/depot/cli/internal/build.Date=#{time.iso8601}
      -X github.com/depot/cli/internal/build.SentryEnvironment=release
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/depot"

    generate_completions_from_executable(bin/"depot", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/depot --version")
    output = shell_output("#{bin}/depot list builds 2>&1", 1)
    assert_match "Error: unknown project ID", output
  end
end
