class Lacquer < Formula
  desc "AI workflows that shine"
  homepage "https://github.com/lacquerai/lacquer"
  url "https://github.com/lacquerai/lacquer/archive/refs/tags/v0.1.7.tar.gz"
  sha256 "c22d8393f56cc89d9665054de3fa03efac16e41ef6a6d9732c5ea1a208377be7"
  license "Apache-2.0"
  head "https://github.com/lacquerai/lacquer.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b7483350710f344afc608828a4e1ba1add340a3018f57c7da472b67c65997e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "847f273f15a1475cfd2d17d5de1be974d2462184daf643c2d68fa88b34cb9e37"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b2b93a15829942c7772c0a0b3d9d76ac7feb374a399e423fe462b472c87df8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "251d32d5004cb8546cee92265ad61b1bc5f93a49250fe763b85e3ba49eaba48b"
    sha256 cellar: :any,                 x86_64_linux:  "59bf2a8335868b7d92c2eb03c022962ba93cb37941e6c462a1e5a35f12cf663a"
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

    generate_completions_from_executable(
      bin/"laq", shell_parameter_format: :cobra, shells: [:bash, :zsh, :fish, :pwsh]
    )
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/laq version")

    (testpath/"empty.laq.yml").write("")
    output = shell_output("#{bin}/laq validate #{testpath}/empty.laq.yml 2>&1", 1)
    assert_match "Workflow file contains no content", output
  end
end
