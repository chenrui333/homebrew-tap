class Lazyjira < Formula
  desc "Fast, keyboard-driven terminal UI for Jira"
  homepage "https://github.com/textfuel/lazyjira"
  url "https://github.com/textfuel/lazyjira/archive/refs/tags/v2.8.1.tar.gz"
  sha256 "7303f8e9eaf094a909306d18fac0e49a8ab7eaac3d781e5368774750f7dad24b"
  license "MIT"
  head "https://github.com/textfuel/lazyjira.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b63c5c96fcfc174aab54eea50824b07ea2b0aa7c659358283a82ecc05ae9ad0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b63c5c96fcfc174aab54eea50824b07ea2b0aa7c659358283a82ecc05ae9ad0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b63c5c96fcfc174aab54eea50824b07ea2b0aa7c659358283a82ecc05ae9ad0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f389df6c42d6c1a73b5d993f71a05ca3e4f23b8e07035568b62efe1dff8547bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b225da1db7886ff732eb1c5265cfe17b3a0893e2c0e81267b3f2fc4c9f4a94a"
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
