class ProcessCompose < Formula
  desc "Flexible scheduler for non-containerized applications"
  homepage "https://f1bonacc1.github.io/process-compose/"
  url "https://github.com/F1bonacc1/process-compose/archive/refs/tags/v1.100.0.tar.gz"
  sha256 "4761d3386c5ec12979aaf554878b0ac5ceb68c83db55451cc83a8b1f42a6d245"
  license "Apache-2.0"
  head "https://github.com/F1bonacc1/process-compose.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb5c5249ec92c3a6efceab945a610d575d7c4bfa007453ee98835302fff32c55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4e083deeb8f4b25c5103e3466a948e3e5a4890f07049b698c30e32d3665a122"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79a1854c8fd6090666228f4b06baf2ccb41b16d6413fca2eb034082866232cc6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bbac12f028149df4cd2dad4c5a29d425b95f5a3a49bb137e67da0c64d447572e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2dfd715650ec2f17e34410c91e2d62cf61163e5f2068b8db41be6ad7a0ff9a66"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/f1bonacc1/process-compose/src/config.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./"

    generate_completions_from_executable(bin/"process-compose", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"process-compose.yaml").write <<~YAML
      version: "0.5"
      processes:
        hello:
          command: /usr/bin/printf 'hello'
    YAML

    assert_match version.to_s, shell_output("#{bin}/process-compose version --short")

    output = shell_output("#{bin}/process-compose -f #{testpath/"process-compose.yaml"} --dry-run 2>&1")
    assert_match "Validated 1 configured processes", output
  end
end
