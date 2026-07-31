class Gsh < Formula
  desc "Battery-included, POSIX-compatible, generative shell"
  homepage "https://github.com/atinylittleshell/gsh"
  url "https://github.com/atinylittleshell/gsh/archive/refs/tags/v1.11.1.tar.gz"
  sha256 "81b8b80fa450bad0a387808b1fb727cda884c8056dbf51f89ac856b2002fa6ed"
  license "GPL-3.0-only"
  head "https://github.com/atinylittleshell/gsh.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "76023641ed06adab508696a4222ea4c6c0b5c871889037dbdfa35c91212c378c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76023641ed06adab508696a4222ea4c6c0b5c871889037dbdfa35c91212c378c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76023641ed06adab508696a4222ea4c6c0b5c871889037dbdfa35c91212c378c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f274ef5c0abcc12ebdd3607d6bcb0039a516080a3ae38c5f71d6920d279c0596"
    sha256 cellar: :any,                 x86_64_linux:  "5d0984a2fda7d43ab9aacc02f4f278f4536cdf80359630abe9943502368d957b"
  end

  depends_on "go" => :build

  def install
    tool_path = buildpath/"build_bin"
    ENV["GOBIN"] = tool_path
    ENV.prepend_path "PATH", tool_path
    system "go", "install", "golang.org/x/tools/cmd/stringer@latest"
    system "go", "generate", "./..."

    ldflags = "-s -w -X main.BUILD_VERSION=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"gsh"), "./cmd/gsh/main.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gsh --version")
    assert_match "Telemetry:", shell_output("#{bin}/gsh telemetry status")
  end
end
