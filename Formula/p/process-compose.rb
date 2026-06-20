class ProcessCompose < Formula
  desc "Flexible scheduler for non-containerized applications"
  homepage "https://f1bonacc1.github.io/process-compose/"
  url "https://github.com/F1bonacc1/process-compose/archive/refs/tags/v1.116.0.tar.gz"
  sha256 "4c0e4989360379a265cf12d06f5681dd9647566a93604201594995ac6472deca"
  license "Apache-2.0"
  head "https://github.com/F1bonacc1/process-compose.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ae9ba1d3e2149d0daa62d63aed65ed757780d828132759f8caf533dbe087291"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad2a6aee815e3230f6dd2928d5553b706c5ee88136a094f73a5fab555dbd1339"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e262ff0d340617e1e5653a0b579ac14c08b6ac61b1c0d6ae9b7a2927b92ee57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e47d4d1ef09277a42efa4a98e8734288ed757f22e16f518b43b5726b944066a5"
    sha256 cellar: :any,                 x86_64_linux:  "d493915895b1693137ae3442890d2c3ec31ebde581f70b3ae2ca99f36e1944b5"
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
