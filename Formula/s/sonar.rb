class Sonar < Formula
  desc "CLI tool for inspecting and managing localhost ports"
  homepage "https://github.com/raskrebs/sonar"
  url "https://github.com/raskrebs/sonar/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "9e987cc9f4c538a202add26817e2396e697a88f73bcb1b76fa1aa6d501a4f4e2"
  license "MIT"
  head "https://github.com/raskrebs/sonar.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b18a1823416b3169099282f30fc421898401c723d056debbbe1bb2913157d181"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b18a1823416b3169099282f30fc421898401c723d056debbbe1bb2913157d181"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b18a1823416b3169099282f30fc421898401c723d056debbbe1bb2913157d181"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd050ef3801e3fb4f3c9ff9959aa1d87ddb5ef23a7cfd526340e134dfab1cd32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5324c1360cad6b5c3390deda7b09eca1733bf99a05f4e15e7262634cb11ea73a"
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
