class Tornado < Formula
  desc "SQLite explorer with Vim key bindings"
  homepage "https://codeberg.org/ozeye/tornado"
  url "https://codeberg.org/ozeye/tornado/archive/v0.4.0.tar.gz"
  sha256 "7b89bf8749f0404cdbd554e93508b4a103004dbf59c0a75c16162d2dd1634422"
  license "MIT"
  head "https://codeberg.org/ozeye/tornado.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/tornado"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tornado --version")
    assert_match "flag provided but not defined", shell_output("#{bin}/tornado --invalid-option 2>&1", 2)
  end
end
