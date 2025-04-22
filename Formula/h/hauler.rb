class Hauler < Formula
  desc "Airgap Swiss Army Knife"
  homepage "https://docs.hauler.dev/docs/intro"
  url "https://github.com/hauler-dev/hauler/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "85865915b57b1ca13ee2fd163cf37e181f3333cc83923b0a07388c68bf550131"
  license "Apache-2.0"
  head "https://github.com/hauler-dev/hauler.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73ed93e448f495a06227e19c7ee736c81bf11552ba8eae32d126342ad62871cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64f410bec2fcb1c11c2146398bb175482c5a3fd28a44cdd2d8689c1ee9d10a10"
    sha256 cellar: :any_skip_relocation, ventura:       "19e4e2136287387dcb8472d566638fe8040c65578b7eedc9c8f7fcf5f81aebf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1142c4f3336a9eb4c102b47a9be6e3ec87203432450d644b28076bacbcde66f1"
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

    generate_completions_from_executable(bin/"hauler", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hauler version")

    assert_match "REFERENCE", shell_output("#{bin}/hauler store info")
  end
end
