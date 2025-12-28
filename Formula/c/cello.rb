class Cello < Formula
  desc "Service for running infrastructure as code software tools"
  homepage "https://github.com/cello-proj/cello"
  url "https://github.com/cello-proj/cello/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "6b471025cfe16385fcdcda495f8d38190c4be05093899e09b88d7ccc68a17142"
  license "Apache-2.0"
  head "https://github.com/cello-proj/cello.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ef5d7e2e6ea88c279fda38ab0b9888502807268988860ce3d5f83de7b4be00f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ef5d7e2e6ea88c279fda38ab0b9888502807268988860ce3d5f83de7b4be00f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ef5d7e2e6ea88c279fda38ab0b9888502807268988860ce3d5f83de7b4be00f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e56dbbe08ebcccdb048c18ef8474fd29bc6ba17e9b201da2ce8cc7db3a2e8395"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5adb9d62ba905d78cabe36dcdac0047595eb64eaae988e1078efc60342d84d93"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cli"

    generate_completions_from_executable(bin/"cello", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cello version")

    output = shell_output("#{bin}/cello list --project_name test --target_name test 2>&1", 1)
    assert_match "connection refused", output
  end
end
