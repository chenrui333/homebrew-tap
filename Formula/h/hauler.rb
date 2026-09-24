class Hauler < Formula
  desc "Airgap Swiss Army Knife"
  homepage "https://docs.hauler.dev/docs/intro"
  url "https://github.com/hauler-dev/hauler/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "d947d36b79ab37ad505e17d7bb88a86751effcb3cb05b2d844ffefc092edeb78"
  license "Apache-2.0"
  head "https://github.com/hauler-dev/hauler.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4356907544d5a2db432367c79d48f74579c8b69bd2ad1d5205e5ad792eff2d87"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "207d882f32c38599a7275a669fad9b4798278ad86f88d1c1a71c638666731b40"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58a3a22a76295c9a47660cf8323eec4e1d40a40d9f8a84b66d1764bf54e49cb3"
    sha256 cellar: :any,                 x86_64_linux:  "b4f8136ce59e50e8c4a9093d25e17c63b146d0359789d7183cc7c1b5701f00e7"
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
