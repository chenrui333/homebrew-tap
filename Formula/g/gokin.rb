class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.50.0.tar.gz"
  sha256 "081096181afcc97e4e0fca6988e6d6eb8ba87c83402766b129b2c437dd0ec889"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3de2ae9f1d2ae4423133da100cdc790c9f453ea1b4b359c24ed06185994427a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3de2ae9f1d2ae4423133da100cdc790c9f453ea1b4b359c24ed06185994427a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3de2ae9f1d2ae4423133da100cdc790c9f453ea1b4b359c24ed06185994427a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d982019f7cb1d684a8288153e41598f8b747b8deb6dd7c0c46ca8992303e896"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "133e6dfc2900eed768997271275ec5f167ede087d823da1af2cce5a43843be4a"
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
