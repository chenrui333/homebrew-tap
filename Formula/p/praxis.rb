class Praxis < Formula
  desc "Declarative infrastructure platform for AWS cloud resources using CUE"
  homepage "https://github.com/shirvan/praxis"
  url "https://github.com/shirvan/praxis/archive/refs/tags/v0.1.0-alpha.1.tar.gz"
  sha256 "2c57165ed1cce528bbfb238a472a6b882d9c65de1bedda248061aa793f4431e3"
  license "Apache-2.0"
  head "https://github.com/shirvan/praxis.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/shirvan/praxis/internal/cli.version=#{version}
      -X github.com/shirvan/praxis/internal/cli.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/praxis"

    generate_completions_from_executable(bin/"praxis", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/praxis version")
    assert_match "deploy", shell_output("#{bin}/praxis --help")
  end
end
