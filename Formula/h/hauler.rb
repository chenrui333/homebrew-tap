class Hauler < Formula
  desc "Airgap Swiss Army Knife"
  homepage "https://docs.hauler.dev/docs/intro"
  url "https://github.com/hauler-dev/hauler/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "cb5a312ffeefb0ec2e163889f62302ef3a42dfcf09f64189d37391877fc707ae"
  license "Apache-2.0"
  head "https://github.com/hauler-dev/hauler.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db2c0579bb52d6ef9aece4aec02c849f4d8c8c9b391955bd5c2e4557a8393e43"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f6afdd182171234614cb294153967ed9202f9679c3b3f0603d7f8a09122f87f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa75b5b08482027d4fb610e236d4739004ea660f9da92f5aee9d84bef979bbf9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa07f0959765fb83d485fd27d2685e3354aa5e61d53428067021cca655cd9040"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d34780cea04e3b44ce734d9381f9223cdd83d542560c27d7b91b3d8cc6827865"
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
