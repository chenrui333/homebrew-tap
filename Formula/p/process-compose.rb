class ProcessCompose < Formula
  desc "Flexible scheduler for non-containerized applications"
  homepage "https://f1bonacc1.github.io/process-compose/"
  url "https://github.com/F1bonacc1/process-compose/archive/refs/tags/v1.94.0.tar.gz"
  sha256 "8e1ce5deefd004ee46728f8944c164341a7bf2e1f1714804724dc10362de6663"
  license "Apache-2.0"
  head "https://github.com/F1bonacc1/process-compose.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "705a519f80ec2199bea884daee09e812653c578acb854cd06796052a6a94114d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2eb55a3ec7237927d31a4a4312b16828dd11fd03951b5b8c4674ccab33675466"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9857bc6418ecb9bcad9789af182a78c96cd0f032092d3c788692bcdfc073ccf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b612b9202723ba637593f5613bd4686fc226b531b9e0f29d8c218dfaf2ee80dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f885ad22bd5edfc7aaee0f691ec5d8c230bfa237f95714a3fc6fce57335c9c74"
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
