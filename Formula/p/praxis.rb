class Praxis < Formula
  desc "Declarative infrastructure platform for AWS cloud resources using CUE"
  homepage "https://github.com/shirvan/praxis"
  url "https://github.com/shirvan/praxis/archive/refs/tags/v0.1.0-alpha.1.tar.gz"
  sha256 "2c57165ed1cce528bbfb238a472a6b882d9c65de1bedda248061aa793f4431e3"
  license "Apache-2.0"
  head "https://github.com/shirvan/praxis.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c9015c422311f200a456338216ef7c4b7a7592a66710b2479abdad5f2d0facf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c9015c422311f200a456338216ef7c4b7a7592a66710b2479abdad5f2d0facf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c9015c422311f200a456338216ef7c4b7a7592a66710b2479abdad5f2d0facf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8cfbff012c7ff5061925159541373365a2b4cf72aa64503ceb502d9fc7643561"
    sha256 cellar: :any,                 x86_64_linux:  "ed0ee0c03b16d270440407fdbe4d1059130d0abeedbd98d3a1b4842895ff887d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/shirvan/praxis/internal/cli.version=#{version}
      -X github.com/shirvan/praxis/internal/cli.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/praxis"

    generate_completions_from_executable(bin/"praxis", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/praxis version")
    output = shell_output("#{bin}/praxis not-a-real-command 2>&1", 1)
    assert_match "unknown command", output
  end
end
