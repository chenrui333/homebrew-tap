class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "804bc0f5144c349d2259ca0954774d8ef724a4d2f8e3d932a71f6ff7231c6917"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5321f5c40b511c35e3ccc673a088f2dad43b959eca84e7e47b2e30e390441378"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0e2bb2b2f3e60d1a1812f4e87a1461c6a3c1570ff35339c9d8ac7e47dd320c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1228fa6c3f5e0cd0337f5aa7cf978cc1c312d0343a2c4fe695a302932db6b9d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f423f7187904004b64c7c4c15cb169d5ae997cc0b0d0adf9bad0f62e7dc712f7"
    sha256 cellar: :any,                 x86_64_linux:  "ad6f219618eebe4544b794abc5a36d9e40f70858ed0c42570e8cb77201b758ef"
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
