class Lacquer < Formula
  desc "AI workflows that shine"
  homepage "https://github.com/lacquerai/lacquer"
  url "https://github.com/lacquerai/lacquer/archive/refs/tags/v0.1.7.tar.gz"
  sha256 "c22d8393f56cc89d9665054de3fa03efac16e41ef6a6d9732c5ea1a208377be7"
  license "Apache-2.0"
  head "https://github.com/lacquerai/lacquer.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a511581dbf9bc97dc4e08f759e7b49a17ba5bd1d6d583aa4d2798ab7befba71"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69e6ab6b2242d5203b4624885d851014c42d8ee71fe9b7fb4829d48f65772f63"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c24d3e2df7d56d54d3be5e0d3cf6cfb4251d89cf0186f048c4f006187fbdc49f"
    sha256 cellar: :any,                 x86_64_linux:  "a651fe39374af5cbaeed6a4a842c12ecd14ac3d1b5577be005ceeec70253b3f2"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/lacquerai/lacquer/internal/cli.Version=#{version}
      -X github.com/lacquerai/lacquer/internal/cli.Commit=#{tap.user}
      -X github.com/lacquerai/lacquer/internal/cli.Date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"laq"), "./cmd/laq"

    generate_completions_from_executable(bin/"laq", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/laq version")

    (testpath/"empty.laq.yml").write("")
    output = shell_output("#{bin}/laq validate #{testpath}/empty.laq.yml 2>&1", 1)
    assert_match "Workflow file contains no content", output
  end
end
