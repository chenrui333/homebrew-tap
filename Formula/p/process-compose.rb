class ProcessCompose < Formula
  desc "Flexible scheduler for non-containerized applications"
  homepage "https://f1bonacc1.github.io/process-compose/"
  url "https://github.com/F1bonacc1/process-compose/archive/refs/tags/v1.122.0.tar.gz"
  sha256 "ec4fc618ccf88d1d049842cb873cfa08f8fbd8d4ee8eff6c3a1c020be8005157"
  license "Apache-2.0"
  head "https://github.com/F1bonacc1/process-compose.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bff750df680995f2aca79df016cd6646690f1a92abdf3486621373b8f23eb60f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82bdffd4296b6c94a2c2dd1a014db21c9395a3a46e91002fb50403423e606c05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4f52892ac6cb394c5846239f54920b74bfaa787ced05bc84c3e298bbda6c4ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b6fbeabaef5508951ac8d77cea691478ce443dfbf80dda380f2847233baa2f5"
    sha256 cellar: :any,                 x86_64_linux:  "4294570bc160820becc880ad71d2fc7c49db2e88a03cc5de31b7afa05b3f8ba5"
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
