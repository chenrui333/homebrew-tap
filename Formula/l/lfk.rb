class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.19.2.tar.gz"
  sha256 "a129b6b7b81382a6983e1cc05e704925cbe8bc763bffa014dc61022ac38a65ea"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a4d8659c16a742259f8127c4a438ec87ae71bb64b67ee182befed9fbf48245e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a4d8659c16a742259f8127c4a438ec87ae71bb64b67ee182befed9fbf48245e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b20b23573828cad7ce3038abe4c53faf4ac21a0d01f8bfcbc3517b63a8fef3cf"
    sha256 cellar: :any,                 x86_64_linux:  "2efcea68cac31f77778f71d0b23fae5c93e0986bb59385a039341334a1fd92b2"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X github.com/janosmiko/lfk/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "."

    generate_completions_from_executable(bin/"lfk", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lfk --version 2>&1")
    output = shell_output("#{bin}/lfk not-a-real-command 2>&1", 1)
    assert_match "unknown command", output
  end
end
