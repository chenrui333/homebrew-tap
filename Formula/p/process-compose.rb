class ProcessCompose < Formula
  desc "Flexible scheduler for non-containerized applications"
  homepage "https://f1bonacc1.github.io/process-compose/"
  url "https://github.com/F1bonacc1/process-compose/archive/refs/tags/v1.120.0.tar.gz"
  sha256 "cb07693970d7272ac907d4724b1216d455310f4cfeb0f5d77896247d2ef3e639"
  license "Apache-2.0"
  head "https://github.com/F1bonacc1/process-compose.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "61f2e767cf1fba799d9f31da54ff8f2c113ee0f09573b2e471c2af4b2ed76b46"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d817f1f6e48815d4c664f2fc0d701210a0d05c794a57ac2498cb026c9ad34d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d00e9c23cfd110c6db993a42a218cad1fea7744bef1e22302fbab803d203042"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e691bada06772a37e8dd1c2c1d1b08a7080d1fbd81005dc2c0eb3d6435423862"
    sha256 cellar: :any,                 x86_64_linux:  "18a49267f22fdc044cf95002ea8e1843bd44c74ad11264253586c0d5c6d8b9c0"
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
