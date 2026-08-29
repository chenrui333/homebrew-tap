class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.36.tar.gz"
  sha256 "9f3a3104a54c80f9168c9944bf58a7ce24f3385cc91f455702f69fbbeae217e3"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "720449eea251966d27da25d16595c633dc2b6b4ca524904b9883c18356a7b561"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "277a83ddb75c321d352951591c396a1edbb4c4ef0887582ae60d514214006069"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe238ae7cbbdcee5d7ba9659d7a3fa8d91538e35c475ad84c9e97a272fca4ef1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5c3b0da840920ae4a388e3df522b433dc715568ca893cd6a654c958facd4df9"
    sha256 cellar: :any,                 x86_64_linux:  "452c8368f9a10605e071f9da7f0d51ea78f8c992ff38f70629a4f59ba0fd6c97"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/RoninForge/budgetclaw/internal/version.version=#{version}
      -X github.com/RoninForge/budgetclaw/internal/version.commit=HEAD
      -X github.com/RoninForge/budgetclaw/internal/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/budgetclaw"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/budgetclaw version")
    assert_match "No activity tracked yet", shell_output("#{bin}/budgetclaw status")
  end
end
