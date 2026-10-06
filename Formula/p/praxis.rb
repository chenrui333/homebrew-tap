class Praxis < Formula
  desc "Declarative infrastructure platform for AWS cloud resources using CUE"
  homepage "https://github.com/shirvan/praxis"
  url "https://github.com/shirvan/praxis/archive/refs/tags/alpha-0.2.0.tar.gz"
  sha256 "8f50d8ad218ea7b1466106406e412d8dbca7474c0c0ad600e256f41379500a73"
  license "Apache-2.0"
  head "https://github.com/shirvan/praxis.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0b08141127a55f5714d6bb6ca0d9f174a43045e4d0c53b5cd3e43af70220859"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0b08141127a55f5714d6bb6ca0d9f174a43045e4d0c53b5cd3e43af70220859"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8916567ccc7e8763fdcde165df420a412056ab6cd43935314d6b90c624f90e7"
    sha256 cellar: :any,                 x86_64_linux:  "ee92032110d7b8370792b98450982640009d9f9765c58010ae388e855708d6de"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
