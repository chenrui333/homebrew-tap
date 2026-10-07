class Timetrace < Formula
  desc "CLI for tracking your working time"
  homepage "https://github.com/dominikbraun/timetrace"
  url "https://github.com/dominikbraun/timetrace/archive/refs/tags/v0.14.3.tar.gz"
  sha256 "670ae0b147ddd6a430efb0a727f1612bcc66fffb025855f151760002c63fb847"
  license "Apache-2.0"
  head "https://github.com/dominikbraun/timetrace.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "56dc0771f29f989b3889be7e62a26cd7813673311db366556e0bf50a2c25f78b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56dc0771f29f989b3889be7e62a26cd7813673311db366556e0bf50a2c25f78b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb7a0a9f48cecac8541bbae86dab8c2887e221fabca34c17cf3a226245839918"
    sha256 cellar: :any,                 x86_64_linux:  "f4becc89cf99930e7685f87aa20abdcecef17c45da111da84719fa70d78388d2"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    # Pre-1.17 go.mod omits indirect deps the build needs; fetch the full module graph.
    system "go", "mod", "download", "all"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"timetrace", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/timetrace --version")

    assert_match "KEY", shell_output("#{bin}/timetrace list projects")
  end
end
