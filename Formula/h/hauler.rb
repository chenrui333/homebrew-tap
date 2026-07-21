class Hauler < Formula
  desc "Airgap Swiss Army Knife"
  homepage "https://docs.hauler.dev/docs/intro"
  url "https://github.com/hauler-dev/hauler/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "29420fc2eaf99c3a751a3a405a9a28ae4a22f4edde042d83d5d2d8634e3c940f"
  license "Apache-2.0"
  head "https://github.com/hauler-dev/hauler.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "851f1e0cfabd59de45c6c20abe841315fbcf882afc15922c0c4b7af05309cf95"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f20bcc3f88379434aa6f6c10f5a1b22b94c05450d62612297f2974ab53e42c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96493d28488f5be6ca9d39448eb6ed8dc890b3a703cf1d90782a442eb7804aec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b3ccdd857b04557d09abde03a5022f5c0e6a8451ad2a552a43c1c7b7f643733"
    sha256 cellar: :any,                 x86_64_linux:  "c99ab98609a3c29d32f494fda0253b4e54047d26468776f5aa8c3064e2d7c5e8"
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
