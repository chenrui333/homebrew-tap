class Lazyjira < Formula
  desc "Fast, keyboard-driven terminal UI for Jira"
  homepage "https://github.com/textfuel/lazyjira"
  url "https://github.com/textfuel/lazyjira/archive/refs/tags/v2.8.1.tar.gz"
  sha256 "7303f8e9eaf094a909306d18fac0e49a8ab7eaac3d781e5368774750f7dad24b"
  license "MIT"
  head "https://github.com/textfuel/lazyjira.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d4c61c3efc4176cfacab3708f3500c0599a6c968cb9f4ff48fb44d68a4ac82bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4c61c3efc4176cfacab3708f3500c0599a6c968cb9f4ff48fb44d68a4ac82bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4c61c3efc4176cfacab3708f3500c0599a6c968cb9f4ff48fb44d68a4ac82bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a35a9a5b6dd3f8040de866dabdc0a939790b0ce4446f6af9687d089755ecb5a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bd3d1a0781ed58e85cccd21cbf8423ea528b85ecdadb63e105e00dbcd5f668a"
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
