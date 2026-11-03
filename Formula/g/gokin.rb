class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.103.1.tar.gz"
  sha256 "b2a8206ebbd981031fb7b4777ba147cbc075dbda75a9be3a5e0bf4d760197828"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b90f0edae81d749d460f490a7e9d4596759dd17689e6be245e6de8caee6d74ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d72484c6ddfc3dbe004249454943dfd0aafc8480f91fae253b2080ef68d4cdbb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38fc9921667835ad744d9dbcc1c39951434f2269461083d9fc8ed5dcf1ecfbd5"
    sha256 cellar: :any,                 x86_64_linux:  "26cbe858b6b2fe2cf7b78be3f8a2014da0e221af6a7ddd02cd2e48d271932ad6"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gokin"

    generate_completions_from_executable(bin/"gokin", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gokin version")
    assert_match "API key not configured", shell_output("#{bin}/gokin doctor")
  end
end
