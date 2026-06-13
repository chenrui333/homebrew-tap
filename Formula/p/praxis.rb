class Praxis < Formula
  desc "Declarative infrastructure platform for AWS cloud resources using CUE"
  homepage "https://github.com/shirvan/praxis"
  url "https://github.com/shirvan/praxis/archive/refs/tags/v0.1.0-alpha.1.tar.gz"
  sha256 "2c57165ed1cce528bbfb238a472a6b882d9c65de1bedda248061aa793f4431e3"
  license "Apache-2.0"
  head "https://github.com/shirvan/praxis.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd2fda26615b99d6392c63d1baf975470a97203bfde04c9fe2ea5411c341d556"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd2fda26615b99d6392c63d1baf975470a97203bfde04c9fe2ea5411c341d556"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd2fda26615b99d6392c63d1baf975470a97203bfde04c9fe2ea5411c341d556"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3ae37311bf051f1edb80cd7d7f9aa7d50b3f23abaf0f3bba6560517830c64fd"
    sha256 cellar: :any,                 x86_64_linux:  "8617f9f8ec867ef0e5651350d5d0ae132a794a9622b2d78e959e52a291a5cbba"
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
    assert_match "deploy", shell_output("#{bin}/praxis --help")
  end
end
