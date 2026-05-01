class ProcessCompose < Formula
  desc "Flexible scheduler for non-containerized applications"
  homepage "https://f1bonacc1.github.io/process-compose/"
  url "https://github.com/F1bonacc1/process-compose/archive/refs/tags/v1.110.0.tar.gz"
  sha256 "70962dce15736e10b2674a3ed3ce9565596239e3299622e33d73d43b23e10930"
  license "Apache-2.0"
  head "https://github.com/F1bonacc1/process-compose.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26667148ac35fa1b646e90fd8b9d3679627609634bc550ebf1b748f85b6dea52"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d82bb04a96e3f1bbbcb2368e04333d607b182b91960f34ce64f1e221b79bc44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2112d1debc9b205919caaaeeaac0dfcd3209f6af643ba601895231f5254e2ba1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3cc4a4dcc1fedf044e33daba6d5648d92650cd54df092bed45ba0768087ab234"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "159d5710529df6d0fb3fef21a47b695c61b2cd8ceef748e11fe750f32508bdfb"
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
