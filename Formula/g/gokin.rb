class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.86.8.tar.gz"
  sha256 "8590e681b87c8772645e89cc3a8d1ae9c1b48bd9c6f7c65fc98dc71e370c8a11"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "253bfa049571982edc83ad1920aebed63dabf278e4d9b05262bfc8b715fc40ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "253bfa049571982edc83ad1920aebed63dabf278e4d9b05262bfc8b715fc40ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "253bfa049571982edc83ad1920aebed63dabf278e4d9b05262bfc8b715fc40ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3684562a3134440bc91f49e8d08d8f75a410fe1e7f3a37811b7e465b9be9e7c"
    sha256 cellar: :any,                 x86_64_linux:  "00e4458b7d934cc735286bdf54fda627d65ca215a026b979332c4a844f60d820"
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
