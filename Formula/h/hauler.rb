class Hauler < Formula
  desc "Airgap Swiss Army Knife"
  homepage "https://docs.hauler.dev/docs/intro"
  url "https://github.com/hauler-dev/hauler/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "d9d3825979a496031ba36e49ba739e4cd32abf1e6683f2109e8eb2dbd8215acb"
  license "Apache-2.0"
  head "https://github.com/hauler-dev/hauler.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc0390576593ef0234063109cfeaff4fc6d641f24cdc6c2321d2bf7abcb3edff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07c333825d556f1af0ea776daf5731c74b012754bc1d944d5a3be52931083fa6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d83ea9be2a4240bc411941af12395ac6083f9d454918cb7a1ef6f30b21094675"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c69fb56faacb36667fba502ea5f5dc57af778aa0b197524b8fddb0d99ff0142"
    sha256 cellar: :any,                 x86_64_linux:  "e359bcb3393b54b1ba77e575e29f931dcafc904d8e3376afd1ca57306b1cda8e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X hauler.dev/go/hauler/v2/internal/version.gitVersion=#{version}
      -X hauler.dev/go/hauler/v2/internal/version.gitCommit=#{tap.user}
      -X hauler.dev/go/hauler/v2/internal/version.gitTreeState=clean
      -X hauler.dev/go/hauler/v2/internal/version.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/hauler"

    generate_completions_from_executable(bin/"hauler", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hauler version")

    assert_match "REFERENCE", shell_output("#{bin}/hauler store info")
  end
end
