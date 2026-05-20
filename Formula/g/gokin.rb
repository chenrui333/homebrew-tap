class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.84.3.tar.gz"
  sha256 "5063dc616230a944e80974d398c5dc7d4573b32484ce945382e80a8f526b833e"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5848ca351fbb1802ae673f0e9f07757f6c2f422b3cb517b78e4954f5c465d5f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5848ca351fbb1802ae673f0e9f07757f6c2f422b3cb517b78e4954f5c465d5f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5848ca351fbb1802ae673f0e9f07757f6c2f422b3cb517b78e4954f5c465d5f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e058f75aecefede572028dbf4383bceb5cbe2f8fab425411243da81f69000670"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ea32f18dce8816aef47473e366cfe708df006d9ee7bbb72134b6070e670d74c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gokin"

    generate_completions_from_executable(bin/"gokin", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gokin version")
    assert_match "Available Commands:", shell_output("#{bin}/gokin --help")
  end
end
