class Praxis < Formula
  desc "Declarative infrastructure platform for AWS cloud resources using CUE"
  homepage "https://github.com/shirvan/praxis"
  url "https://github.com/shirvan/praxis/archive/refs/tags/v0.1.0-alpha.1.tar.gz"
  sha256 "2c57165ed1cce528bbfb238a472a6b882d9c65de1bedda248061aa793f4431e3"
  license "Apache-2.0"
  head "https://github.com/shirvan/praxis.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e135648d8789661cf4a383ad2aff773d49557912a5dfb093950c856d147efca9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e135648d8789661cf4a383ad2aff773d49557912a5dfb093950c856d147efca9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e135648d8789661cf4a383ad2aff773d49557912a5dfb093950c856d147efca9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e8799db9ab05f2c25d521bd6859889e29f6200b0955c88f3094acecc7c96a7d"
    sha256 cellar: :any,                 x86_64_linux:  "d47cea0cb505ee9e64a4c1b0f0a7a9a8f87044404945d81e4ce249e86a7593ad"
  end

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
    output = shell_output("#{bin}/praxis not-a-real-command 2>&1", 1)
    assert_match "unknown command", output
  end
end
