class Tracetest < Formula
  desc "Build integration and end-to-end tests"
  homepage "https://docs.tracetest.io/"
  url "https://github.com/kubeshop/tracetest/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "9f2fb4edab3e469465302c70bcddf0f48517306db0004afdc1d016f30b5380e5"
  license "MIT" # MIT license for the CLI, TCL license for agent

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de8cb80fec226f21dc28dc462d638fb7bff6d4c41573ee4f4419b8c745f0e383"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a106741a9ed51edbc1d1fe02563c161fe1dd062ca5aeba7e0e14b6bc1bf63e77"
    sha256 cellar: :any_skip_relocation, ventura:       "893356af7bef3d256877da3772230615d13a57c700905579c208048f246d0593"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8532e00110b32759c93724a3193e3b885d138f168b117c46e2d6ccc84eea46d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/kubeshop/tracetest/cli/config.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cli"

    generate_completions_from_executable(bin/"tracetest", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tracetest version 2>&1", 1)

    assert_match "Server: Not Configured", shell_output("#{bin}/tracetest list 2>&1", 1)
  end
end
