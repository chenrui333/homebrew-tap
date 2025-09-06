class Lacquer < Formula
  desc "AI workflows that shine"
  homepage "https://github.com/lacquerai/lacquer"
  url "https://github.com/lacquerai/lacquer/archive/refs/tags/v0.1.7.tar.gz"
  sha256 "c22d8393f56cc89d9665054de3fa03efac16e41ef6a6d9732c5ea1a208377be7"
  license "Apache-2.0"
  head "https://github.com/lacquerai/lacquer.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/lacquerai/lacquer/internal/cli.Version=#{version}
      -X github.com/lacquerai/lacquer/internal/cli.Commit=#{tap.user}
      -X github.com/lacquerai/lacquer/internal/cli.Date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"laq"), "./cmd/laq"

    generate_completions_from_executable(bin/"laq", "completion", shells: [:bash, :zsh, :fish, :pwsh])
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
