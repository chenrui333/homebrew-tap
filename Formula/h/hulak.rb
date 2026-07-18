class Hulak < Formula
  desc "Lightweight file-based API client with encrypted secrets store"
  homepage "https://github.com/xaaha/hulak"
  url "https://github.com/xaaha/hulak/archive/refs/tags/v0.3.30.tar.gz"
  sha256 "2556158d94b726bff6c132510a8e0c8889053b4129a15b4b3054ea3e20c7439e"
  license "MIT"
  head "https://github.com/xaaha/hulak.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a414797b8559e8f89f4129b386d9d8c52247611db996733d9ed4a479b952305"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a414797b8559e8f89f4129b386d9d8c52247611db996733d9ed4a479b952305"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a414797b8559e8f89f4129b386d9d8c52247611db996733d9ed4a479b952305"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7621361d44315526afe74318bacfabe7da0f9aaf2c1653292f55b94c24082fd8"
    sha256 cellar: :any,                 x86_64_linux:  "cc4dbcc25a878262a800d214bdd6c22de1240c51ec66761aabe766b3f1ed2e43"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/xaaha/hulak/pkg/userFlags.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hulak version")
    assert_match "Initialize a hulak project", shell_output("#{bin}/hulak help")
  end
end
