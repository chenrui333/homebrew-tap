class Hauler < Formula
  desc "Airgap Swiss Army Knife"
  homepage "https://docs.hauler.dev/docs/intro"
  url "https://github.com/hauler-dev/hauler/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "8f140063587f985d8b48c8355772a67b840e050ab64b63512aab42dba223b0ea"
  license "Apache-2.0"
  head "https://github.com/hauler-dev/hauler.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1cf67e379e7adc77deb73bacca15778d37b0a21e0746fdafdd9148d9dcbed8b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "216843a7bcab1b8c8e5758f7d731ecc5b2754363c22222e8d0c6c6e88f926291"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9fd8a110712a1545426d97734d753220c5f38ae9668208ed760116df250d9b74"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05da4b7c4719554d9879e8e6d1e302743c838661506b527694c5d166eadbf4ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9bf8aaa0ee7ba5ee5f94588aedb80a5e596c058795779658b0d677ff0a32b65"
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
