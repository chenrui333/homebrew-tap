class Que < Formula
  desc "Pipe-able DevOps assistant"
  homepage "https://github.com/njenia/que"
  url "https://github.com/njenia/que/archive/refs/tags/v1.0.6.tar.gz"
  sha256 "7a409b65f7d8cb5bb978f53a91a790cc47582c100a1b207752ee805e31755d02"
  license "MIT"
  head "https://github.com/njenia/que.git", branch: "main"

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
