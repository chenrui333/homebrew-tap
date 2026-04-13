class Rum < Formula
  desc "TUI to list, search and run package.json scripts"
  homepage "https://github.com/thekarel/rum"
  url "https://github.com/thekarel/rum/archive/refs/tags/v1.2.8.tar.gz"
  sha256 "ede17ed43f6a76f94f2571a6c2c2a19b433db440d5d8efcb65ca2f31c2ffc0ea"
  license "MIT"
  head "https://github.com/thekarel/rum.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b1a3551ac24dd129bf0797dc9d7c2d38fea98356380d19af361e1c45ea6897a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b1a3551ac24dd129bf0797dc9d7c2d38fea98356380d19af361e1c45ea6897a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b1a3551ac24dd129bf0797dc9d7c2d38fea98356380d19af361e1c45ea6897a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a99d90c31c4e578ef87a5541d9a7def3a09ef44b11dad888e900f759029b18e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "133b9b559d879d15e263b03abe8cb5428e8b7e339e943ffebc4f1af922a1ba10"
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
