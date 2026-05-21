class Sonar < Formula
  desc "CLI tool for inspecting and managing localhost ports"
  homepage "https://github.com/raskrebs/sonar"
  url "https://github.com/raskrebs/sonar/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "68f632e1923f2015461b961e428ecb6bf949709f9ab9017bb5e2fa515196ce1d"
  license "MIT"
  head "https://github.com/raskrebs/sonar.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48c309b47d8deeada4b79e6b04ff259187d25b3c7ed205220c2bf2ac828929f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48c309b47d8deeada4b79e6b04ff259187d25b3c7ed205220c2bf2ac828929f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48c309b47d8deeada4b79e6b04ff259187d25b3c7ed205220c2bf2ac828929f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e98366b0b70c0b7bf2297e4de8ec36839020bc99065d0af04e799869d72a98f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a95b041dbf8d5c9106de24f103272a73414e7e34d8405085518cda0213fa57b4"
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
