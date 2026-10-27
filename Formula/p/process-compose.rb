class ProcessCompose < Formula
  desc "Flexible scheduler for non-containerized applications"
  homepage "https://f1bonacc1.github.io/process-compose/"
  url "https://github.com/F1bonacc1/process-compose/archive/refs/tags/v1.124.0.tar.gz"
  sha256 "1e2fcdfd141d0f4591db266cbf42f20ccee7621183405cec794f762cec33e3ac"
  license "Apache-2.0"
  head "https://github.com/F1bonacc1/process-compose.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "85f7483fad3d9f617969c682f49b0e13acaeb9e5c8bbb2d1cc58e5e333fe4d82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cfffaa9f50e8d233d8cf2ef1d67901c338fe6245d71bebfe9373c2056ac6b2d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0e162b6aa66964ad4911af253f490b21e9e69767af2f40ae32c9c86bdb929c9"
    sha256 cellar: :any,                 x86_64_linux:  "240f543666b36d47c38268c25f150a1497a89bf3c84673d5bbb1c949e69acf8e"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
