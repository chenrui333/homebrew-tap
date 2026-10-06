class Que < Formula
  desc "Pipe-able DevOps assistant"
  homepage "https://github.com/njenia/que"
  url "https://github.com/njenia/que/archive/refs/tags/v1.0.6.tar.gz"
  sha256 "7a409b65f7d8cb5bb978f53a91a790cc47582c100a1b207752ee805e31755d02"
  license "MIT"
  head "https://github.com/njenia/que.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6999f4e1e253bff74298042a19b05c7cfa8b6e947874ed6e5ce34d3765bc466f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6999f4e1e253bff74298042a19b05c7cfa8b6e947874ed6e5ce34d3765bc466f"
    sha256 cellar: :any,                 arm64_linux:   "312869d04e9c1c6afc61a78c5c87eb565ddce887f3096004f3f007a5becd9ce0"
    sha256 cellar: :any,                 x86_64_linux:  "803784abe057de632af58817f5610e292f352cf9e6ad2504b1a737b17a226e08"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    # Workaround to avoid patchelf corruption when cgo is required
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/que"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/que --version")

    (testpath/"test.txt").write("Hello, Que!")
    output = pipe_output("#{bin}/que --dry-run 2>&1", (testpath/"test.txt").read)
    assert_match "Would query LLM API (skipped in dry-run mode)", output
  end
end
