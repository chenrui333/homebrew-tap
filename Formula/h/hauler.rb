class Hauler < Formula
  desc "Airgap Swiss Army Knife"
  homepage "https://docs.hauler.dev/docs/intro"
  url "https://github.com/hauler-dev/hauler/archive/refs/tags/v2.1.2.tar.gz"
  sha256 "7e1d8a71b4084ca43142c8a5bc421ffb94b289c13379d44185495f1b67400991"
  license "Apache-2.0"
  head "https://github.com/hauler-dev/hauler.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6de02b726622358b3eefb747c28f7af1b5a7dc760e8b742b5633776e3dfcf748"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "593a906b7b0321c6f321363dbbc93539a2bf6ebd4448031fddf69e8a20a3643b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c40523d51962f2cb80e827e61c649ab59d3bf54fa03fe076c38a1f8955473c01"
    sha256 cellar: :any,                 x86_64_linux:  "7ed7f8ad2913c538f6239fd793b3f7142eebb263ab1df1997818c8c7de263501"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
