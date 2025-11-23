class Que < Formula
  desc "Pipe-able DevOps assistant"
  homepage "https://github.com/njenia/que"
  url "https://github.com/njenia/que/archive/refs/tags/v1.0.6.tar.gz"
  sha256 "7a409b65f7d8cb5bb978f53a91a790cc47582c100a1b207752ee805e31755d02"
  license "MIT"
  head "https://github.com/njenia/que.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "480dde9dad8877d19608803cb4246bfac009fd24ee18f746e2a17c5be21db5fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "480dde9dad8877d19608803cb4246bfac009fd24ee18f746e2a17c5be21db5fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "480dde9dad8877d19608803cb4246bfac009fd24ee18f746e2a17c5be21db5fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83ebd9672f5c024a42472e821daa03c155b1830c8898b97cb04837936be6ad6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd067c9ee4980906e5f1c417d58733010e532e7f0e28a4d7dfcb3fbd23872998"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"

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
