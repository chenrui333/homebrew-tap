class Sonar < Formula
  desc "CLI tool for inspecting and managing localhost ports"
  homepage "https://github.com/raskrebs/sonar"
  url "https://github.com/raskrebs/sonar/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "68f632e1923f2015461b961e428ecb6bf949709f9ab9017bb5e2fa515196ce1d"
  license "MIT"
  head "https://github.com/raskrebs/sonar.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "72d3d56dca2fd8518323bcf12da916fcc5933066a6f85916198fff467a5d5ba7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72d3d56dca2fd8518323bcf12da916fcc5933066a6f85916198fff467a5d5ba7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72d3d56dca2fd8518323bcf12da916fcc5933066a6f85916198fff467a5d5ba7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c43fd1c7fa5e13ad0a43f3cc0c9bed34c5fc23350da8adf7bfa18dd0e5fdbc7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "982c9e2f301c388966d90992ca67489bdafc508739aef431beae7fa1cc614315"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/raskrebs/sonar/internal/selfupdate.Version=v#{version}"

    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"sonar",
                                         shell_parameter_format: :cobra,
                                         shells:                 [:bash, :zsh, :fish])
  end

  test do
    require "socket"

    server = TCPServer.new("127.0.0.1", 0)
    port = server.addr[1]

    assert_match version.to_s, shell_output("#{bin}/sonar version")

    system bin/"sonar", "wait", port.to_s, "--quiet", "--timeout", "1s"
  ensure
    server&.close
  end
end
