class ProcessCompose < Formula
  desc "Flexible scheduler for non-containerized applications"
  homepage "https://f1bonacc1.github.io/process-compose/"
  url "https://github.com/F1bonacc1/process-compose/archive/refs/tags/v1.122.0.tar.gz"
  sha256 "ec4fc618ccf88d1d049842cb873cfa08f8fbd8d4ee8eff6c3a1c020be8005157"
  license "Apache-2.0"
  head "https://github.com/F1bonacc1/process-compose.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1cc41398327facc2f8c070636a2b949b3c1a1188470a83cf791179b56c4ddc1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c81378828d1ebba090a9177531fb48a2317b11c2d58675ef8e531fc63421f94"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be685c2f002079b2979873fa73fc4002b671d3d5d6c6908ebe0269f6bbd30999"
    sha256 cellar: :any,                 x86_64_linux:  "dff2ab6a52078782ee4078a8125242253225027583fef4bca593f144ffb64ed0"
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
