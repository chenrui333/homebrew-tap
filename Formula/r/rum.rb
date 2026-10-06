class Rum < Formula
  desc "TUI to list, search and run package.json scripts"
  homepage "https://github.com/thekarel/rum"
  url "https://github.com/thekarel/rum/archive/refs/tags/v1.2.8.tar.gz"
  sha256 "ede17ed43f6a76f94f2571a6c2c2a19b433db440d5d8efcb65ca2f31c2ffc0ea"
  license "MIT"
  head "https://github.com/thekarel/rum.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22899a4753b1cf61a6b0a8718f787f48441c9d76298f5a234dd3a5371aa7c032"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22899a4753b1cf61a6b0a8718f787f48441c9d76298f5a234dd3a5371aa7c032"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d88579079f1ecea8e07bad324359ffdf3464d5a748fae641af09a42487b8717"
    sha256 cellar: :any,                 x86_64_linux:  "f52b325b4e08306f212bbac8333fdcec148bec3515b3ca49f4e4b7542e5ac079"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
