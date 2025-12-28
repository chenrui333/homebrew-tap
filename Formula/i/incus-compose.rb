class IncusCompose < Formula
  desc "Missing equivalent for `docker-compose` in the Incus ecosystem"
  homepage "https://github.com/bketelsen/incus-compose"
  url "https://github.com/bketelsen/incus-compose/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "b7505fb5d92a0b30ed3bf014208ccad8d754f48f1eb4f2b6627201bdefdc4056"
  license "MIT"
  head "https://github.com/bketelsen/incus-compose.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "abfec86d5ccd85bf2cecf0e32bde3fffa347968d7eb454a800412598f15fa064"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "abfec86d5ccd85bf2cecf0e32bde3fffa347968d7eb454a800412598f15fa064"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abfec86d5ccd85bf2cecf0e32bde3fffa347968d7eb454a800412598f15fa064"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc66bd3445077478f156ee3319c1b2d27626e737e51e672934f81f7be4f05f35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b8b3c8acf8221f795a46028877f42c0e32fea95344a4c11f5e04b0c9ea04e6d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/bketelsen/incus-compose/cmd.date=#{time.iso8601}
      -X github.com/bketelsen/incus-compose/cmd.treeState=clean
      -X github.com/bketelsen/incus-compose/cmd.version=#{version}
      -X github.com/bketelsen/incus-compose/cmd.commit=#{tap.user}
      -X github.com/bketelsen/incus-compose/cmd.builtBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"incus-compose", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/incus-compose --version")

    assert_match "no compose.yaml file found", shell_output("#{bin}/incus-compose up 2>&1", 1)
  end
end
