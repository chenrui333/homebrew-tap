class Sonar < Formula
  desc "CLI tool for inspecting and managing localhost ports"
  homepage "https://github.com/raskrebs/sonar"
  url "https://github.com/raskrebs/sonar/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "447230c9a9715a00dba52ddfdec489e76938c0df86470f43207be3fb85a35d61"
  license "MIT"
  head "https://github.com/raskrebs/sonar.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "684c9cb0545a102b092eb89a50233313b79162a652aec9ee6409c363e5ef27cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "684c9cb0545a102b092eb89a50233313b79162a652aec9ee6409c363e5ef27cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "684c9cb0545a102b092eb89a50233313b79162a652aec9ee6409c363e5ef27cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa2eb1123fec7b81defdcd1a3d568c42800e923e18f3cad4aea3d41e31b878ff"
    sha256 cellar: :any,                 x86_64_linux:  "74f22b90586ee0701c4f8566daf00552e288cd2bc56c078c7f92a4319b6c1ddb"
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
