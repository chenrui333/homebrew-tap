class Rum < Formula
  desc "TUI to list, search and run package.json scripts"
  homepage "https://github.com/thekarel/rum"
  url "https://github.com/thekarel/rum/archive/refs/tags/v1.2.8.tar.gz"
  sha256 "ede17ed43f6a76f94f2571a6c2c2a19b433db440d5d8efcb65ca2f31c2ffc0ea"
  license "MIT"
  head "https://github.com/thekarel/rum.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b28a02ea4d2034cff4e94cc9004916d6971461dd1e45bc98a71f04258aa6253d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b28a02ea4d2034cff4e94cc9004916d6971461dd1e45bc98a71f04258aa6253d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b28a02ea4d2034cff4e94cc9004916d6971461dd1e45bc98a71f04258aa6253d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50fe6cba8276f25b3904dbeb8cbb7a2491080eef6b2c91a2ed0c8ef777232f1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfdda290489baa373ff29ebaf9ccd6443f71a2421358e18b80c865e1c20c9e8d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"package.json").write <<~JSON
      {
        "name": "test-package",
        "version": "1.0.0",
        "scripts": {
          "start": "echo Starting",
          "test": "echo Testing"
        }
      }
    JSON

    output = shell_output("#{bin}/rum -l #{testpath}/package.json")
    assert_match "start    echo Starting", output
  end
end
