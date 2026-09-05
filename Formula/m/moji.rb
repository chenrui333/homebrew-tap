class Moji < Formula
  desc "Find, inspect and convert fonts"
  homepage "https://github.com/Microck/moji"
  url "https://github.com/Microck/moji/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "43989e70b8dba28180e5a9bbbc51c833d74a4ebe652a2a263b266d8eea9983f4"
  license "MIT"
  head "https://github.com/Microck/moji.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/microck/moji/internal/app.Version=#{version}"), "./cmd/moji"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/moji --version")
    output = shell_output("#{bin}/moji 2>&1", 2)
    assert_match "font query is required in non-interactive mode", output
  end
end
