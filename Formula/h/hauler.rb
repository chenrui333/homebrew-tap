class Hauler < Formula
  desc "Airgap Swiss Army Knife"
  homepage "https://docs.hauler.dev/docs/intro"
  url "https://github.com/hauler-dev/hauler/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "2a51430e8a88d055f744c948ca14d640b846a9ed2de9ec2f50a92a102d69cd06"
  license "Apache-2.0"
  head "https://github.com/hauler-dev/hauler.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "25f22c50cb660f4c8950073d38b6383956e1315d82916fb51fc2a3532b6f56d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4785a641ad639616e63013ace2bc0dca7fde549e583adc9495b020e12dc0652"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43162779af7b686c5de0859dcebbf8bd46e142812b9ac40e2ccb965f696f3e85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ea1123d10e3faee7234266978c9cb8c3cff63952091186205a7071ae45c9da9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfdea6ae45eba8b6593fdb08e1b632aabf62ad87385ae529db68c9be492e8721"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X hauler.dev/go/hauler/internal/version.gitVersion=#{version}
      -X hauler.dev/go/hauler/internal/version.gitCommit=#{tap.user}
      -X hauler.dev/go/hauler/internal/version.gitTreeState=clean
      -X hauler.dev/go/hauler/internal/version.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/hauler"

    generate_completions_from_executable(bin/"hauler", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hauler version")

    assert_match "REFERENCE", shell_output("#{bin}/hauler store info")
  end
end
