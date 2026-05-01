class ProcessCompose < Formula
  desc "Flexible scheduler for non-containerized applications"
  homepage "https://f1bonacc1.github.io/process-compose/"
  url "https://github.com/F1bonacc1/process-compose/archive/refs/tags/v1.110.0.tar.gz"
  sha256 "70962dce15736e10b2674a3ed3ce9565596239e3299622e33d73d43b23e10930"
  license "Apache-2.0"
  head "https://github.com/F1bonacc1/process-compose.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "489ea937a59eeb2b82bb4bef292a834bfde873beb3ce39d98081a4276411824d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70506db72995610600e76135b2ae82bebdf7307ac36eb940a96f0faf91bc35de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d711129995917faac630d0b8db811e23fc6f0cacfd886331ed9dcfd53eb1a37a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf358d46b976206bf9d163cf8c455076807b70a4eb4def19ca8cc205da250387"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85443804e8054284fee41785e71b0d197a88803f70f921d4f11a400e00cc4ddc"
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
