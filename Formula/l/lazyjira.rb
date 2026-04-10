class Lazyjira < Formula
  desc "Fast, keyboard-driven terminal UI for Jira"
  homepage "https://github.com/textfuel/lazyjira"
  url "https://github.com/textfuel/lazyjira/archive/refs/tags/v2.7.4.tar.gz"
  sha256 "327293e87febc07d7ec9045934c05342b4f85b2f0263d4a15200e273717258bf"
  license "MIT"
  head "https://github.com/textfuel/lazyjira.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0f3240f80a7bc3e0eeb4cfb6252022bf52fcab318d92f0617744a8a8a85f7f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0f3240f80a7bc3e0eeb4cfb6252022bf52fcab318d92f0617744a8a8a85f7f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0f3240f80a7bc3e0eeb4cfb6252022bf52fcab318d92f0617744a8a8a85f7f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99cac2e9b8281118201e4a3c9249a7ac31eb195f55b962218b88936723cfe4e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c896e12806dc832d3f77c41e72c38ba29680ae38b4f9f67c1d7245bf6b73efb9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    ENV["GOFLAGS"] = "-buildvcs=false"
    system "go", "build", *std_go_args(ldflags:), "./cmd/lazyjira"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazyjira --version")
  end
end
