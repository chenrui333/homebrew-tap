class Hauler < Formula
  desc "Airgap Swiss Army Knife"
  homepage "https://docs.hauler.dev/docs/intro"
  url "https://github.com/hauler-dev/hauler/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "85865915b57b1ca13ee2fd163cf37e181f3333cc83923b0a07388c68bf550131"
  license "Apache-2.0"
  head "https://github.com/hauler-dev/hauler.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea44e876878121d65faedbdebe3e813b119e1f5c258c8af0e90eac259375139c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0e0ab5e0157465b161ad3ca5320cab7c68f54179665e921b744109480f856a8"
    sha256 cellar: :any_skip_relocation, ventura:       "3ba9525ef9f1dd39331c3ec99e519083fddd4c571a035b69ae615a0689ca80cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7d6836ebf54a25139b6a4ec068753598ad41ef22e6458936a2ba777d598db84"
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
