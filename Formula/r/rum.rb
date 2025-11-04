class Rum < Formula
  desc "TUI to list, search and run package.json scripts"
  homepage "https://github.com/thekarel/rum"
  url "https://github.com/thekarel/rum/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "a14ee56cc8354afb648ec922afd00a2325ff2b26c453c889679186b7bb3254f3"
  license "MIT"
  head "https://github.com/thekarel/rum.git", branch: "main"

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
