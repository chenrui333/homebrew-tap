class Rum < Formula
  desc "TUI to list, search and run package.json scripts"
  homepage "https://github.com/thekarel/rum"
  url "https://github.com/thekarel/rum/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "2db4b64eac92d7212ad47a3ff8e786f083bcde1bda5f68d8e5fe2d94895d19c7"
  license "MIT"
  head "https://github.com/thekarel/rum.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2bcd864da4d35d8d2ab4c04f615aa3a9f3205b585745487a7bc1cd22d7df4c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2bcd864da4d35d8d2ab4c04f615aa3a9f3205b585745487a7bc1cd22d7df4c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2bcd864da4d35d8d2ab4c04f615aa3a9f3205b585745487a7bc1cd22d7df4c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2bf6a118e14e7be2583144d2462d61c059588e7ad9dfa205766a29d6e4516fec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25fbf0e379b4f74c7acbd3fdd821f9ce511de1cb37a62870417ffe1ad56e4bc4"
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

    output = shell_output("#{bin}/rum #{testpath}/package.json --help")
    assert_match "TUI to list, filter and run package.json scripts", output
  end
end
