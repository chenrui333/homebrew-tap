class Sonar < Formula
  desc "CLI tool for inspecting and managing localhost ports"
  homepage "https://github.com/raskrebs/sonar"
  url "https://github.com/raskrebs/sonar/archive/refs/tags/v0.2.8.tar.gz"
  sha256 "bc32db90c44e884dbadddbb30f9a3cecd23843e5529b32a5f30bb0cd94dbbf76"
  license "MIT"
  head "https://github.com/raskrebs/sonar.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f41bb5855189fc6094008b6e1013759c1a036e757fad875c34185974515fa950"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f41bb5855189fc6094008b6e1013759c1a036e757fad875c34185974515fa950"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f41bb5855189fc6094008b6e1013759c1a036e757fad875c34185974515fa950"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4a62f3978e6bb2dceb78b38387c528f74209b305c003f1ac48f336252cb797a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a17cf01189c122597e25488fb20a1679c7964cb9379ab7cb0c826f39bfe99003"
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
