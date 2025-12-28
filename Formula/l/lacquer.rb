class Lacquer < Formula
  desc "AI workflows that shine"
  homepage "https://github.com/lacquerai/lacquer"
  url "https://github.com/lacquerai/lacquer/archive/refs/tags/v0.1.7.tar.gz"
  sha256 "c22d8393f56cc89d9665054de3fa03efac16e41ef6a6d9732c5ea1a208377be7"
  license "Apache-2.0"
  head "https://github.com/lacquerai/lacquer.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "180afbe33799e88599d1edc3c1fcdf7c01806a0a208b18552bbd115c74c1ed95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce78ac0e99e974f5d2ba670e77135346ee34585e318206feed0e091fe4f85b66"
    sha256 cellar: :any_skip_relocation, ventura:       "cdd50fb52b46bd3fddf06e062715e943c1afa1304d2cef02c9e81fb59e310873"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bb7ef0cc47a544d4548e60a1fdf3f64ebf9acab04058f418cd68b3621730c8e"
  end

  depends_on "go" => :build

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

    output = shell_output("#{bin}/laq init --name 'test' " \
                          "--description 'app test' --providers anthropic --non-interactive")
    assert_match "Generated files", output
    assert_path_exists testpath/"test/workflow.laq.yml"

    system bin/"laq", "validate", testpath/"test/workflow.laq.yml"
  end
end
